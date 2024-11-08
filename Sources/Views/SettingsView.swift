
import Cocoa

class SettingsView: NSWindowController {
    init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )

        window.title = "Settings"
        window.center()
        window.level = .floating

        super.init(window: window)

        let contentView = NSView(frame: window.contentView!.bounds)
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = NSColor(hex: "282b30").cgColor
        window.contentView = contentView

        setupSettingsContent(in: contentView)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSettingsContent(in view: NSView) {
        let label = NSTextField(labelWithString: "Settings Page")
        label.font = NSFont.systemFont(ofSize: 24)
        label.alignment = .center
        label.textColor = .white
        label.frame = NSRect(x: 50, y: view.bounds.height / 2 - 12, width: 300, height: 24)
        view.addSubview(label)
    }
}

extension NSColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        var color: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&color)

        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(color & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
