//
//  HomeViewController.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 19/11/25.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController, CategoryBarViewDelegate {
    
    // MARK: Properties
    private var contentItems: [UnsplashPhotoResponse] = []
    private var isTwoColumnLayout = false
    private let cellSpacing: CGFloat = 2.5

    // MARK: UI
    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.register(HomeCollectionViewCell.self,
                            forCellWithReuseIdentifier: "HomeCell")
        collection.backgroundColor = .black
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private let categoryBar = CategoryBarView()
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        categoryBar.setCategories(["Editorial", "Wallpapers", "3D Renders", "Nature", "Textures"])
        categoryBar.delegate = self
      

        
        configureNavigationBar()
        addSubview()
        fetchPhotos()
        makeConstraints()
    }
    
    private func fetchPhotos() {
        print("💡 Fetching photos...")
        NetworkManager.getEditorialPhotos { result in
            switch result {
            case .success(let photos):
                self.contentItems = photos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("❌ Error fetching photos:", error)
            }
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false

        // MARK: - Left: Logo
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let leftItem = UIBarButtonItem(customView: logoImageView)
        
        navigationItem.leftBarButtonItem = leftItem

        // MARK: - Center: Title
        navigationItem.title = "Unsplash"

        // MARK: - Right: Action icon (menu / grid)
        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(systemName: isTwoColumnLayout ? "rectangle.split.2x1" : "square.grid.2x2.fill" ), for: .normal)
        menuButton.tintColor = .white
        menuButton.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: menuButton)
        navigationItem.rightBarButtonItem = rightItem

        // MARK: - Appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    @objc private func didTapMenuButton() {
        isTwoColumnLayout.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.layoutIfNeeded()
        }
        
        if let menuButton = navigationItem.rightBarButtonItem?.customView as? UIButton {
            let iconName = isTwoColumnLayout ? "rectangle.split.2x1.fill" : "square.grid.2x2.fill"
            menuButton.setImage(UIImage(systemName: iconName), for: .normal)
        }
    }

   
    
    private func addSubview() {
        view.addSubview(collectionView)
        view.addSubview(categoryBar)
    }
    
    private func makeConstraints() {
        
        categoryBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - DataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return contentItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HomeCell",
            for: indexPath
        ) as! HomeCollectionViewCell
        
        cell.content = contentItems[indexPath.item]
        return cell
    }
}

// MARK: - Layout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photo = contentItems[indexPath.item]
        let numberOfColumns: CGFloat = isTwoColumnLayout ? 2 : 1
        
        let totalSpacing = (numberOfColumns - 1) * cellSpacing
        let collectionWidth = collectionView.bounds.width
        let cellWidth = (collectionWidth - totalSpacing) / numberOfColumns
        
        let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let photoHeight = cellWidth * aspectRatio
        let extraHeight: CGFloat = 60
        
        return CGSize(width: cellWidth, height: photoHeight + extraHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return isTwoColumnLayout ? cellSpacing : 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return isTwoColumnLayout ? cellSpacing : 0
    }

}


extension HomeViewController {
    func didSelectCategory(index: Int) {
        print("Selected category at index: \(index)")
    }
}
