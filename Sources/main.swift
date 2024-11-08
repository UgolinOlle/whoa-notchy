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
        let yPosition = screenSize.height - windowSize.height
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
        window.collectionBehavior = [.canJoinAllSpaces, .transient]
        window.makeKeyAndOrderFront(nil)

        let notchView = NotchView(
            frame: NSRect(x: 0, y: 0, width: windowSize.width, height: windowSize.height)
        )

        window.contentView?.addSubview(notchView)

        notchView.frame.origin = NSPoint(x: 0, y: 0)
        notchView.autoresizingMask = [.width, .height]
    }
}

class NotchView: NSView {
    private var isExpanded = false
    private let originalSize: NSSize

    override init(frame frameRect: NSRect) {
        self.originalSize = frameRect.size
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func mouseDown(with event: NSEvent) {
        isExpanded.toggle()

        let newHeight = isExpanded ? originalSize.height * 1.5 : originalSize.height
        let newSize = NSSize(width: originalSize.width, height: newHeight)

        if let window = self.window {
            let screenFrame = window.screen!.frame
            let xPosition = (screenFrame.width - newSize.width) / 2
            let yPosition = screenFrame.height - originalSize.height  // Position initiale en haut-centre

            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.3
                window.animator().setFrame(
                    NSRect(origin: NSPoint(x: xPosition, y: yPosition), size: newSize),
                    display: true)
                self.animator().frame.size = newSize
            })
        }
    }

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
            x: (bounds.width - textSize.width) / 2,
            y: (bounds.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height)
        text.draw(in: textRect, withAttributes: textAttributes)
    }
}
