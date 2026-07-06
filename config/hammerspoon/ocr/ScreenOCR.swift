import Cocoa
import CoreImage
import ScreenCaptureKit
import Vision

final class OverlayWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

final class SelectionView: NSView {
    let frozen: NSImage
    let cgImage: CGImage
    let scale: CGFloat
    var start: NSPoint?
    var selection: NSRect = .zero
    var onFinish: ((CGImage?) -> Void)?

    init(frame: NSRect, image: NSImage, cgImage: CGImage, scale: CGFloat) {
        self.frozen = image
        self.cgImage = cgImage
        self.scale = scale
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) { fatalError() }

    override var acceptsFirstResponder: Bool { true }

    override func resetCursorRects() {
        addCursorRect(bounds, cursor: .crosshair)
    }

    override func draw(_ dirtyRect: NSRect) {
        frozen.draw(in: bounds)
        NSColor(white: 0.0, alpha: 0.45).setFill()
        bounds.fill()
        guard !selection.isEmpty else { return }
        // Restore the original (undimmed) pixels inside the selection.
        frozen.draw(in: selection, from: selection, operation: .sourceOver, fraction: 1.0)
        NSColor.controlAccentColor.setStroke()
        let border = NSBezierPath(rect: selection)
        border.lineWidth = 1.5
        border.stroke()
    }

    private func rect(from a: NSPoint, to b: NSPoint) -> NSRect {
        NSRect(x: min(a.x, b.x), y: min(a.y, b.y),
               width: abs(a.x - b.x), height: abs(a.y - b.y))
    }

    override func mouseDown(with event: NSEvent) {
        start = convert(event.locationInWindow, from: nil)
        selection = .zero
        needsDisplay = true
    }

    override func mouseDragged(with event: NSEvent) {
        guard let start else { return }
        selection = rect(from: start, to: convert(event.locationInWindow, from: nil))
        needsDisplay = true
    }

    override func mouseUp(with event: NSEvent) {
        // Ignore accidental clicks / tiny drags.
        guard selection.width > 3, selection.height > 3 else {
            onFinish?(nil)
            return
        }
        let x = Int((selection.origin.x * scale).rounded())
        let y = Int(((bounds.height - selection.maxY) * scale).rounded()) // flip to top-left
        let w = Int((selection.width * scale).rounded())
        let h = Int((selection.height * scale).rounded())
        let cropRect = CGRect(x: x, y: y, width: w, height: h)
            .intersection(CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        onFinish?(cgImage.cropping(to: cropRect))
    }

    override func rightMouseDown(with event: NSEvent) {
        onFinish?(nil) // right-click dismisses
    }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 { onFinish?(nil) } // Esc
    }
}

final class Controller {
    var windows: [OverlayWindow] = []
    var finished = false

    func start() {
        Task { @MainActor in
            do {
                let content = try await SCShareableContent.excludingDesktopWindows(
                    false, onScreenWindowsOnly: false)
                var captures: [(NSScreen, CGImage)] = []
                for screen in NSScreen.screens {
                    guard let number = screen.deviceDescription[
                        NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID,
                        let display = content.displays.first(where: { $0.displayID == number })
                    else { continue }

                    let filter = SCContentFilter(display: display, excludingWindows: [])
                    let config = SCStreamConfiguration()
                    config.width = Int(CGFloat(display.width) * screen.backingScaleFactor)
                    config.height = Int(CGFloat(display.height) * screen.backingScaleFactor)
                    config.showsCursor = false
                    config.captureResolution = .best
                    let cg = try await SCScreenshotManager.captureImage(
                        contentFilter: filter, configuration: config)
                    captures.append((screen, cg))
                }
                self.present(captures)
            } catch {
                fputs("ScreenOCR capture failed: \(error)\n", stderr)
                NSApp.terminate(nil)
            }
        }
    }

    func present(_ captures: [(NSScreen, CGImage)]) {
        for (screen, cg) in captures {
            let image = NSImage(cgImage: cg, size: screen.frame.size)
            let window = OverlayWindow(contentRect: screen.frame, styleMask: .borderless,
                                       backing: .buffered, defer: false)
            window.level = NSWindow.Level(rawValue: Int(CGShieldingWindowLevel()))
            window.backgroundColor = .clear
            window.isOpaque = false
            window.ignoresMouseEvents = false
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]

            let view = SelectionView(frame: NSRect(origin: .zero, size: screen.frame.size),
                                     image: image, cgImage: cg, scale: screen.backingScaleFactor)
            view.onFinish = { [weak self] cropped in self?.finish(cropped) }
            window.contentView = view
            window.makeFirstResponder(view)
            window.setFrame(screen.frame, display: true)
            window.orderFrontRegardless()
            windows.append(window)
        }

        guard !windows.isEmpty else { NSApp.terminate(nil); return }
        windows.first?.makeKey()
        NSApp.activate(ignoringOtherApps: true)
    }

    func finish(_ cropped: CGImage?) {
        guard !finished else { return }
        finished = true
        for w in windows { w.orderOut(nil) }
        guard let cropped else { NSApp.terminate(nil); return }
        recognize(cropped)
    }

    // Pre-OCR contrast boost
    static let enhanceContrast = true

    func recognize(_ image: CGImage) {
        let input = Controller.enhanceContrast ? Controller.enhanced(image) : image
        Task {
            let text = await Controller.performOCR(on: input)
            await MainActor.run {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(text, forType: .string)
                NSApp.terminate(nil)
            }
        }
    }

    /// Route to the best recognizer the running OS offers, degrading gracefully:
    /// document/table structure (26+) → plain text (15+).
    static func performOCR(on image: CGImage) async -> String {
        if #available(macOS 26.0, *), let tables = await recognizeDocument(in: image) {
            return tables
        }
        return await recognizeText(in: image)
    }

    // MARK: - Text recognition

    static func recognizeText(in image: CGImage) async -> String {
        var request = RecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.automaticallyDetectsLanguage = true
        request.minimumTextHeightFraction = 0.0 // don't drop small text (default is nonzero)
        do {
            let observations = try await request.perform(on: image)
            return observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
        } catch {
            fputs("ScreenOCR text recognition failed: \(error)\n", stderr)
            return ""
        }
    }

    // MARK: - Document recognition (macOS 26+)

    @available(macOS 26.0, *)
    static func recognizeDocument(in image: CGImage) async -> String? {
        let request = RecognizeDocumentsRequest()
        guard let observations = try? await request.perform(on: image) else { return nil }

        var tableBlocks: [String] = []
        var tableBoxes: [NormalizedRect] = []
        var plainParts: [String] = []

        for observation in observations {
            let doc = observation.document

            for table in doc.tables {
                let rows: [[String]] = table.rows.map { row in
                    row.map { $0.content.text.transcript }
                }
                guard rows.contains(where: { row in row.contains { !$0.isEmpty } }) else { continue }
                tableBlocks.append(rows.map { $0.joined(separator: "\t") }.joined(separator: "\n"))
                let lineBoxes = table.rows.flatMap { row in
                    row.flatMap { $0.content.text.lines.map(\.boundingBox) }
                }
                if let box = enclosingBox(of: lineBoxes) { tableBoxes.append(box) }
            }

            // Keep only paragraphs that don't sit inside a detected table.
            for paragraph in doc.paragraphs {
                guard let box = enclosingBox(of: paragraph.lines.map(\.boundingBox)) else { continue }
                if !tableBoxes.contains(where: { overlaps($0, box) }) {
                    plainParts.append(paragraph.transcript)
                }
            }
        }

        guard !tableBlocks.isEmpty else { return nil }

        var parts: [String] = []
        let plain = plainParts.joined(separator: "\n")
        if !plain.isEmpty { parts.append(plain) }
        parts.append(contentsOf: tableBlocks)
        return parts.joined(separator: "\n\n")
    }

    @available(macOS 26.0, *)
    static func enclosingBox(of boxes: [NormalizedRect]) -> NormalizedRect? {
        guard !boxes.isEmpty else { return nil }
        var minX = Double.greatestFiniteMagnitude, minY = Double.greatestFiniteMagnitude
        var maxX = -Double.greatestFiniteMagnitude, maxY = -Double.greatestFiniteMagnitude
        for b in boxes {
            minX = min(minX, b.origin.x)
            minY = min(minY, b.origin.y)
            maxX = max(maxX, b.origin.x + b.width)
            maxY = max(maxY, b.origin.y + b.height)
        }
        return NormalizedRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    @available(macOS 26.0, *)
    static func overlaps(_ a: NormalizedRect, _ b: NormalizedRect) -> Bool {
        a.origin.x < b.origin.x + b.width && a.origin.x + a.width > b.origin.x &&
        a.origin.y < b.origin.y + b.height && a.origin.y + a.height > b.origin.y
    }

    // MARK: - Image enhancement

    static func enhanced(_ image: CGImage) -> CGImage {
        let ciImage = CIImage(cgImage: image)
        guard let filter = CIFilter(name: "CIColorControls") else { return image }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(1.3, forKey: kCIInputContrastKey)
        filter.setValue(0.1, forKey: kCIInputBrightnessKey)
        filter.setValue(1.1, forKey: kCIInputSaturationKey)
        guard let output = filter.outputImage,
              let cg = CIContext().createCGImage(output, from: output.extent) else { return image }
        return cg
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let controller = Controller()
controller.start()
app.run()
