import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let screenSize = NSScreen.main?.frame.size ?? NSSize(width: 800, height: 600)
        let windowSize = NSSize(width: 250, height: 20)

        let xPosition = (screenSize.width - windowSize.width) / 2
        let yPosition = screenSize.height - windowSize.height + 15
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
