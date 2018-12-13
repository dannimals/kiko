
public protocol ViewStylePreparing {

    func setup()
    func setupViews()
    func setupText()
    func setupColors()
    func setupAnimations()
    func setupFonts()
}

public extension ViewStylePreparing {

    func setup() {
        setupViews()
        setupText()
        setupColors()
        setupFonts()
        setupAnimations()
    }

    func setupViews() {}
    func setupText() {}
    func setupColors() {}
    func setupAnimations() {}
    func setupFonts() {}
}
