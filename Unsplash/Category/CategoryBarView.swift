    import UIKit
    import SnapKit

    protocol CategoryBarViewDelegate: AnyObject {
        func didSelectCategory(index: Int)
    }

    final class CategoryBarView: UIView {

        weak var delegate: CategoryBarViewDelegate?

        private var categories: [String] = []
        private var selectedIndex = 0

        private lazy var collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

            let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.backgroundColor = .clear
            cv.showsHorizontalScrollIndicator = false
            cv.delegate = self
            cv.dataSource = self
            cv.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseId)
            return cv
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupUI() {
            addSubview(collectionView)

            collectionView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        func setCategories(_ items: [String]) {
            self.categories = items
            collectionView.reloadData()
            
            if categories.count > 0 {
                   collectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                             animated: false,
                                             scrollPosition: [])
               }
        }
    }

    extension CategoryBarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            categories.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCell.reuseId,
                for: indexPath
            ) as! CategoryCell

            cell.configure(with: categories[indexPath.item])
            cell.isSelected = (indexPath.item == selectedIndex)
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let previousIndexPath = IndexPath(item: selectedIndex, section: 0)
            if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? CategoryCell {
                previousCell.isSelected = false
            }
            
            if let currentCell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
                currentCell.isSelected = true
            }

            selectedIndex = indexPath.item
            
            delegate?.didSelectCategory(index: selectedIndex)
        }


        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let title = categories[indexPath.item]
            let width = title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 15)]).width + 24
            return CGSize(width: width, height: 40)
        }
    }
