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
        let windowSize = NSSize(width: 250, height: 20)

        let xPosition = (screenSize.width - windowSize.width) / 2
        let yPosition = screenSize.height - windowSize.height + 15  // Ajout de +15 pour la position initiale
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
        window.level = .mainMenu + 3
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
    private let expandedSize = NSSize(width: 350, height: 150)
    private var outsideClickMonitor: Any?

    override init(frame frameRect: NSRect) {
        self.originalSize = frameRect.size
        super.init(frame: frameRect)

        self.wantsLayer = true
        self.layer?.shadowColor = NSColor.black.cgColor
        self.layer?.shadowOpacity = 0.5
        self.layer?.shadowRadius = 10
        self.layer?.shadowOffset = CGSize(width: 0, height: -5)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func mouseDown(with event: NSEvent) {
        isExpanded.toggle()
        setNeedsDisplay(bounds)

        let newSize = isExpanded ? expandedSize : originalSize

        if let window = self.window {
            let screenFrame = window.screen!.frame
            let xPosition = (screenFrame.width - newSize.width) / 2
            let yPosition = screenFrame.height - newSize.height + 15  // Ajout de +15 pour la position en mode agrandi

            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.5
                window.animator().setFrame(
                    NSRect(origin: NSPoint(x: xPosition, y: yPosition), size: newSize),
                    display: true)
                self.animator().frame.size = newSize
            })

            if isExpanded {
                startOutsideClickMonitor()
            } else {
                stopOutsideClickMonitor()
            }
        }
    }

    private func startOutsideClickMonitor() {
        outsideClickMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) {
            [weak self] event in
            guard let self = self, let window = self.window, let contentView = window.contentView
            else { return }
            let clickLocation = NSPoint(x: event.locationInWindow.x, y: event.locationInWindow.y)
            let windowLocation = window.convertPoint(fromScreen: clickLocation)
            let localPoint = contentView.convert(windowLocation, from: nil)
            let clickInsideWindow = contentView.bounds.contains(localPoint)

            if !clickInsideWindow && self.isExpanded {
                self.toggleSize()
            }
        }
    }

    private func stopOutsideClickMonitor() {
        if let monitor = outsideClickMonitor {
            NSEvent.removeMonitor(monitor)
            outsideClickMonitor = nil
        }
    }

    private func toggleSize() {
        isExpanded = false
        setNeedsDisplay(bounds)
        let newSize = originalSize

        if let window = self.window {
            let screenFrame = window.screen!.frame
            let xPosition = (screenFrame.width - newSize.width) / 2
            let yPosition = screenFrame.height - newSize.height + 15  // Ajout de +15 pour la position en mode réduit

            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.3
                window.animator().setFrame(
                    NSRect(origin: NSPoint(x: xPosition, y: yPosition), size: newSize),
                    display: true)
                self.animator().frame.size = newSize
            })
        }

        stopOutsideClickMonitor()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.black.setFill()
        let path = NSBezierPath(roundedRect: bounds, xRadius: 10, yRadius: 10)
        path.fill()

        if isExpanded {
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
}
