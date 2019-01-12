import KikoUIKit

class MoodListView: UIView, ViewStylePreparing {

    let closeButtonTapped = Channel<UIControlEvents>()

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var downwardArrow: AnimatedDownwardArrow!

    func configure(dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    func setupViews() {
        setupCollectionView()
        setupCloseButton()
    }

    func setupColors() {
        backgroundColor = .clear
        collectionView.backgroundColor = .blue05
        headerView.backgroundColor = .blue05
    }

    private func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(notifyCloseButtonTappedEvent), for: .touchUpInside)
    }

    @objc private func notifyCloseButtonTappedEvent() { closeButtonTapped.broadcast(UIControlEvents.touchUpInside) }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: bounds.width - 50, height: 150)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 18
        layout.headerReferenceSize = CGSize(width: 0, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 18, left: 25, bottom: 18, right: 25)
        layout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = layout
        collectionView.registerNibCell(MoodListCollectionViewCell.self)
        collectionView.registerViewClass(MoodListHeaderCell.self)
        collectionView.contentInset.bottom = 100
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let location = touches.first?.location(in: self)
//        print("touches began: \(location!)")
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let location = touches.first?.location(in: self)
//        print("touches moved: \(location!)")
//    }
}
