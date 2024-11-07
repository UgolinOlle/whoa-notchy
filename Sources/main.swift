import Cocoa

@main
struct MyApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let screenSize = NSScreen.main?.frame.size ?? NSSize(width: 800, height: 600)
        let windowSize = NSSize(width: 250, height: 50)

        let xPosition = (screenSize.width - windowSize.width) / 2
        let yPosition = screenSize.height - windowSize.height  // Position en haut de l'écran
        window = NSWindow(
            contentRect: NSRect(
                origin: NSPoint(x: xPosition, y: yPosition),
                size: windowSize),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.makeKeyAndOrderFront(nil)

        let notchView = NotchView(
            frame: NSRect(x: 0, y: 0, width: windowSize.width, height: windowSize.height)
        )

        window.contentView?.addSubview(notchView)

        // Positionner NotchView en haut et centré
        notchView.frame.origin = NSPoint(
            x: (windowSize.width - notchView.frame.width) / 2,  // Centré horizontalement
            y: 0  // Positionné en haut de la fenêtre
        )
        notchView.autoresizingMask = [.width, .height]
    }
}

class NotchView: NSView {
    private var isExpanded = false

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.black.setFill()
        let path = NSBezierPath(roundedRect: bounds, xRadius: 20, yRadius: 20)
        path.fill()

        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.white,
            .font: NSFont.systemFont(ofSize: 16),
        ]
        let text = "Dynamic Island"
        let textSize = text.size(withAttributes: textAttributes)
        let textRect = NSRect(
            x: (bounds.width - textSize.width) / 2, y: (bounds.height - textSize.height) / 2,
            width: textSize.width, height: textSize.height)
        text.draw(in: textRect, withAttributes: textAttributes)
    }
}
