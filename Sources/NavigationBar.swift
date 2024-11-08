import Cocoa

class NavigationBar: NSView {
    private let versionLabel: NSTextField
    private let settingsButton: NSButton
    private let marginTop: CGFloat = 10
    private var settingsView: SettingsView?
    weak var notchView: NotchView?

    override init(frame frameRect: NSRect) {
        versionLabel = NSTextField(labelWithString: "Version 1.0.0")

        if #available(macOS 11.0, *) {
            let gearImage = NSImage(
                systemSymbolName: "gearshape", accessibilityDescription: "Settings"
            )!
            gearImage.isTemplate = true
            settingsButton = NSButton(
                image: gearImage, target: nil, action: #selector(settingsButtonClicked)
            )
            settingsButton.contentTintColor = NSColor.gray
        } else {
            settingsButton = NSButton(
                title: "⚙️", target: nil, action: #selector(settingsButtonClicked)
            )
        }

        super.init(frame: frameRect)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.black.cgColor

        versionLabel.textColor = .lightGray
        versionLabel.isEditable = false
        versionLabel.isBezeled = false
        versionLabel.drawsBackground = false
        versionLabel.sizeToFit()
        versionLabel.frame.origin = NSPoint(
            x: 10,
            y: (bounds.height - versionLabel.frame.height) / 2 - marginTop
        )
        addSubview(versionLabel)

        settingsButton.isBordered = false
        settingsButton.bezelStyle = .shadowlessSquare
        settingsButton.frame = NSRect(
            x: bounds.width - 40,
            y: (bounds.height - 24) / 2 - marginTop,
            width: 24,
            height: 24
        )
        settingsButton.target = self
        addSubview(settingsButton)
    }

    @objc private func settingsButtonClicked() {
        if settingsView == nil {
            settingsView = SettingsView()
        }

        notchView?.closeNotchView()

        settingsView?.showWindow(self)
    }

    override func layout() {
        super.layout()
        settingsButton.frame.origin = NSPoint(
            x: bounds.width - 40,
            y: (bounds.height - 24) / 2 - marginTop
        )
    }
}
