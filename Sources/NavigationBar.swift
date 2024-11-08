import Cocoa

class NavigationBar: NSView {
    private let versionLabel: NSTextField
    private let settingsButton: NSButton
    private let marginTop: CGFloat = 10

    override init(frame frameRect: NSRect) {
        versionLabel = NSTextField(labelWithString: "Version 1.0.0")

        if #available(macOS 11.0, *) {
            let gearImage = NSImage(
                systemSymbolName: "gearshape", accessibilityDescription: "Settings")!
            gearImage.isTemplate = true
            settingsButton = NSButton(
                image: gearImage, target: nil, action: #selector(settingsButtonClicked))
            settingsButton.contentTintColor = NSColor.gray
        } else {
            settingsButton = NSButton(
                title: "⚙️", target: nil, action: #selector(settingsButtonClicked))
        }

        super.init(frame: frameRect)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.black.cgColor

        versionLabel.textColor = .lightGray  // Définit la couleur du texte de version en gris
        versionLabel.isEditable = false
        versionLabel.isBezeled = false
        versionLabel.drawsBackground = false
        versionLabel.sizeToFit()
        versionLabel.frame.origin = NSPoint(
            x: 10,
            y: (self.bounds.height - versionLabel.frame.height) / 2 - marginTop
        )
        addSubview(versionLabel)

        settingsButton.isBordered = false
        settingsButton.bezelStyle = .shadowlessSquare
        settingsButton.frame = NSRect(
            x: self.bounds.width - 40,
            y: (self.bounds.height - 24) / 2 - marginTop,
            width: 24,
            height: 24
        )
        settingsButton.target = self
        addSubview(settingsButton)
    }

    @objc private func settingsButtonClicked() {
        print("Settings button clicked")
    }

    override func layout() {
        super.layout()
        settingsButton.frame.origin = NSPoint(
            x: self.bounds.width - 40,
            y: (self.bounds.height - 24) / 2 - marginTop
        )
    }
}
