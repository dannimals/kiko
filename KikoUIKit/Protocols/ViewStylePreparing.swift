
public protocol ViewStylePreparing {

    func setup()
    func setupViews()
    func setupText()
    func setupColors()
    func setupAnimations()
    func setupFonts()
    func setupBindings()
}

public extension ViewStylePreparing {

    func setup() {
        setupBindings()
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
    func setupBindings() {}
}
