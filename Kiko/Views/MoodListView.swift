import KikoUIKit

class MoodListView: UIView {

    let closeButtonTapped = Channel<UIControlEvents>()

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    func configure(dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
        setupCollectionView()
        setupCloseButton()
        setupColors()
    }

    private func setupColors() {
        backgroundColor = .clear
        collectionView.backgroundColor = .lightBlue
        headerView.backgroundColor = .lightBlue
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
        collectionView.register(UINib(nibName: MonthResultCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MonthResultCollectionViewCell.identifier)
        collectionView.register(MonthResultHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MonthResultHeaderCell.identifier)
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

}
