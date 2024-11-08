import Cocoa

class NotchView: NSView {
    private var isExpanded = false
    private let originalSize: NSSize
    private let expandedSize = NSSize(width: 350, height: 150)
    private var outsideClickMonitor: Any?
    private let hoverIncrease: CGFloat = 10
    private var isHovered = false
    private let navigationBar: NavigationBar

    override init(frame frameRect: NSRect) {
        self.originalSize = frameRect.size
        self.navigationBar = NavigationBar(
            frame: NSRect(x: 0, y: frameRect.height - 40, width: frameRect.width, height: 40))

        super.init(frame: frameRect)

        self.wantsLayer = true
        if let layer = self.layer {
            layer.shadowColor = NSColor.black.cgColor
            layer.shadowOpacity = 0.8
            layer.shadowRadius = 20
            layer.shadowOffset = CGSize(width: 0, height: -10)
        }

        let trackingArea = NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: self,
            userInfo: nil)
        addTrackingArea(trackingArea)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func mouseDown(with event: NSEvent) {
        isExpanded.toggle()
        updateViewSize()

        if isExpanded {
            addSubview(navigationBar)
        } else {
            navigationBar.removeFromSuperview()
        }

        startOutsideClickMonitor()
    }

    override func mouseEntered(with event: NSEvent) {
        isHovered = true
        updateViewSize()
    }

    override func mouseExited(with event: NSEvent) {
        isHovered = false
        updateViewSize()
    }

    private func updateViewSize() {
        let newSize: NSSize

        if isExpanded {
            newSize = expandedSize
        } else if isHovered {
            newSize = NSSize(
                width: originalSize.width + hoverIncrease,
                height: originalSize.height + hoverIncrease)
        } else {
            newSize = originalSize
        }

        if let window = self.window {
            let screenFrame = window.screen!.frame
            let xPosition = (screenFrame.width - newSize.width) / 2
            let yPosition = screenFrame.height - newSize.height + 15

            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.3
                window.animator().setFrame(
                    NSRect(origin: NSPoint(x: xPosition, y: yPosition), size: newSize),
                    display: true)
                self.animator().frame.size = newSize
            })
        }
    }

    private func startOutsideClickMonitor() {
        if outsideClickMonitor == nil {
            outsideClickMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) {
                [weak self] event in
                guard let self = self, let window = self.window else { return }
                if !window.frame.contains(event.locationInWindow) {
                    self.isExpanded = false
                    self.updateViewSize()
                    self.navigationBar.removeFromSuperview()
                    self.stopOutsideClickMonitor()
                }
            }
        }
    }

    private func stopOutsideClickMonitor() {
        if let monitor = outsideClickMonitor {
            NSEvent.removeMonitor(monitor)
            outsideClickMonitor = nil
        }
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

    override func layout() {
        super.layout()

        if isExpanded {
            navigationBar.frame = NSRect(
                x: 0, y: bounds.height - 40, width: bounds.width, height: 40)
        }
    }
}
