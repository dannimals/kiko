
import KikoUIKit

class MoodListView: UIView {

    let closeButtonTapped = Channel<UIControlEvents>()

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    func configure(dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
        setupCollectionView()
        setupCloseButton()
    }

    private func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(notifyCloseButtonTappedEvent), for: .touchUpInside)
    }

    @objc private func notifyCloseButtonTappedEvent() { closeButtonTapped.broadcast(UIControlEvents.touchUpInside) }

    private func setupCollectionView() {
        collectionView.register(UINib(nibName: MonthResultCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MonthResultCollectionViewCell.identifier)
        collectionView.register(MonthResultHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MonthResultHeaderCell.identifier)
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

}
