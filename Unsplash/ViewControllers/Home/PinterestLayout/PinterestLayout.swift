//
//  PinterestLayout.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 25/11/25.
//


import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAt indexPath: IndexPath,
                        cellWidth: CGFloat) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {

    weak var delegate: PinterestLayoutDelegate?

    var numberOfColumns: Int = 2 {
        didSet {
            cache.removeAll()
            contentHeight = 0
            invalidateLayout()
        }
    }

    var cellSpacing: CGFloat = 1

    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0

    private var width: CGFloat {
        return collectionView?.bounds.width ?? 0
    }

    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }

        // Total spacing between columns
        let totalSpacing = cellSpacing * CGFloat(numberOfColumns - 1)

        // Width for each cell
        let columnWidth = (width - totalSpacing) / CGFloat(numberOfColumns)

        // X offsets for columns
        var xOffset: [CGFloat] = []
        for col in 0..<numberOfColumns {
            let x = CGFloat(col) * (columnWidth + cellSpacing)
            xOffset.append(x)
        }

        var column = 0
        var yOffset = Array(repeating: CGFloat(0), count: numberOfColumns)

  
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {

            let indexPath = IndexPath(item: item, section: 0)

            let cellHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAt: indexPath,
                cellWidth: columnWidth
            ) ?? 180


            let frame = CGRect(
                x: xOffset[column],
                y: yOffset[column],
                width: columnWidth,
                height: cellHeight
            )

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] += cellHeight + cellSpacing

            // Move to next shortest column
            if let minIndex = yOffset.enumerated().min(by: { $0.element < $1.element })?.offset {
                column = minIndex
            }
        }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {

        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {

        return cache[indexPath.item]
    }

    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
        contentHeight = 0
    }
}
