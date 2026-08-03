local M = {}

local bundleID = "com.xiaogd.Doll"
local outlookNames = { "Microsoft Outlook", "Outlook" }
local pollInterval = 0.2
local stepTimeout = 8
local addDelay = 5

local function stopTimer()
    if not M.timer then return end
    M.timer:stop()
    M.timer = nil
end

local function fail(message)
    stopTimer()
    hs.alert.show("Doll reset failed: " .. message)
end

local function mainWindow()
    local app = hs.application.get(bundleID)
    if not app then return nil end

    local appElement = hs.axuielement.applicationElement(app)
    local window = appElement and appElement:attributeValue("AXMainWindow")
    if window then return window end

    local windows = appElement and appElement:attributeValue("AXWindows") or {}
    return windows[1]
end

local function findElement(root, predicate)
    if not root then return nil end

    local visited = 0
    local function visit(element, depth)
        if depth > 20 or visited > 2000 then return nil end
        visited = visited + 1

        if predicate(element) then return element end
        for _, child in ipairs(element:attributeValue("AXChildren") or {}) do
            local match = visit(child, depth + 1)
            if match then return match end
        end
        return nil
    end

    return visit(root, 0)
end

local function normalized(value) return type(value) == "string" and value:lower() or "" end

local function elementContains(element, names)
    local attributes = { "AXTitle", "AXDescription", "AXValue", "AXHelp", "AXIdentifier" }
    for _, attribute in ipairs(attributes) do
        local value = normalized(element:attributeValue(attribute))
        for _, name in ipairs(names) do
            if value:find(name:lower(), 1, true) then return true end
        end
    end
    return false
end

local function findByText(names)
    return findElement(mainWindow(), function(element) return elementContains(element, names) end)
end

local function findByRole(role, predicate)
    return findElement(mainWindow(), function(element)
        return element:attributeValue("AXRole") == role and (not predicate or predicate(element))
    end)
end

local function press(element)
    for _ = 1, 8 do
        if not element then return false end
        for _, action in ipairs(element:actionNames() or {}) do
            if action == "AXPress" then return element:performAction("AXPress") ~= nil end
        end
        element = element:attributeValue("AXParent")
    end
    return false
end

local function clickCenter(element)
    local position = element:attributeValue("AXPosition")
    local size = element:attributeValue("AXSize")
    if not position or not size then return false end

    hs.eventtap.leftClick({ x = position.x + size.w / 2, y = position.y + size.h / 2 })
    return true
end

local function closeConfigWindow()
    local app = hs.application.get(bundleID)
    local window = app and app:mainWindow()
    if window then window:close() end
end

local function waitFor(description, lookup, continuation)
    stopTimer()
    local started = hs.timer.secondsSinceEpoch()

    M.timer = hs.timer.doEvery(pollInterval, function()
        local result = lookup()
        if result then
            stopTimer()
            continuation(result)
        elseif hs.timer.secondsSinceEpoch() - started >= stepTimeout then
            fail("could not find " .. description)
        end
    end)
    M.timer:fire()
end

local function chooseOutlook()
    waitFor("Outlook in the app picker", function()
        return findByRole("AXStaticText", function(element) return elementContains(element, { "Microsoft Outlook" }) end)
    end, function(outlook)
        if not clickCenter(outlook) then return fail("could not select Outlook") end
        M.timer = hs.timer.doAfter(0.5, function()
            M.timer = nil
            closeConfigWindow()
            hs.alert.show("Doll Outlook monitor reset")
        end)
    end)
end

local function searchForOutlook()
    waitFor("the app search field", function()
        return findByRole("AXTextField", function(element)
            local placeholder = normalized(element:attributeValue("AXPlaceholderValue"))
            return placeholder == "" or placeholder:find("select an app", 1, true)
        end)
    end, function(field)
        field:setAttributeValue("AXFocused", true)
        M.timer = hs.timer.doAfter(0.1, function()
            M.timer = nil
            hs.eventtap.keyStroke({ "cmd" }, "a", 0)
            hs.eventtap.keyStrokes("Microsoft Outlook")
            chooseOutlook()
        end)
    end)
end

local function openAddView()
    waitFor("the Add button", function()
        return findByText({ "Add", "plus" })
    end, function(addButton)
        if not press(addButton) then return fail("could not open the app picker") end
        searchForOutlook()
    end)
end

local function removeOutlook()
    waitFor("Stop monitoring", function()
        return findByText({ "Stop monitoring" })
    end, function(stopButton)
        if not press(stopButton) then return fail("could not stop Outlook monitoring") end
        M.timer = hs.timer.doAfter(addDelay, function()
            M.timer = nil
            openAddView()
        end)
    end)
end

function M.resetOutlook()
    stopTimer()

    local app = hs.application.get(bundleID)
    if not app then return fail("Doll is not running (it was not restarted)") end

    app:activate(true)
    waitFor("the Outlook monitor", function() return findByText(outlookNames) end, function(outlook)
        if not press(outlook) then return fail("could not open the Outlook monitor") end
        removeOutlook()
    end)
end

return M
