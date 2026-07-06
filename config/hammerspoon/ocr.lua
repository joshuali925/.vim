local M = {}

local src = hs.configdir .. "/ocr/ScreenOCR.swift"
local bin = hs.configdir .. "/ocr/screen-ocr"

local function ensureBinary()
    local binAttr = hs.fs.attributes(bin)
    local srcAttr = hs.fs.attributes(src)
    if binAttr and srcAttr and binAttr.modification >= srcAttr.modification then return true end
    local cmd = string.format(
        "xcrun swiftc -O -target arm64-apple-macos15 -o %q %q -framework Cocoa -framework Vision -framework ScreenCaptureKit",
        bin, src)
    local _, ok, _, rc = hs.execute(cmd, true)
    if not ok then
        hs.alert.show("OCR: build failed (rc=" .. tostring(rc) .. ")")
        return false
    end
    return true
end

function M.capture()
    if not ensureBinary() then return true end
    hs.task.new(bin, nil):start()
    return true
end

return M
