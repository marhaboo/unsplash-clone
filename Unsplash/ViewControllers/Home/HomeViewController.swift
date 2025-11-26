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
    private var categoryItems: [UnsplashTopicResponse] = []
    private var isTwoColumnLayout = false
    private let cellSpacing: CGFloat = 1

    // MARK: UI
    private lazy var collectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        layout.numberOfColumns = isTwoColumnLayout ? 2 : 1
        layout.cellSpacing = cellSpacing

        
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
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
        
        categoryBar.delegate = self

      

        
        configureNavigationBar()
        addSubview()
        fetchPhotos()
        fetchTopics()
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
    
    private func fetchTopics() {
        print("💡 Fetching topics...")
        
        NetworkManager.getTopics { result in
            switch result {
            case .success(let topics):
                self.categoryItems = topics

                DispatchQueue.main.async {
                    let titles = topics.map { $0.title }
                    self.categoryBar.setCategories(titles)
                }

            case .failure(let error):
                print("❌ Error fetching topics:", error)
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

        // MARK: - Right: Action icon
        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(systemName: isTwoColumnLayout ? "rectangle.split.2x1.fill" : "square.grid.2x2.fill" ), for: .normal)
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

        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.numberOfColumns = isTwoColumnLayout ? 2 : 1
            layout.cellSpacing = cellSpacing
        }

        UIView.animate(withDuration: 0.25) {
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.layoutIfNeeded()
        }

        if let btn = navigationItem.rightBarButtonItem?.customView as? UIButton {
            let icon = isTwoColumnLayout ? "rectangle.split.2x1.fill" : "square.grid.2x2.fill"
            btn.setImage(UIImage(systemName: icon), for: .normal)
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

}


extension HomeViewController {
    func didSelectCategory(index: Int) {
        guard index >= 0, index < categoryItems.count else {return}
        let topic = categoryItems[index]
        
        let vc = TopicPhotosViewController(topicTitle: topic.title, topicSlug: topic.slug)
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension HomeViewController: PinterestLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAt indexPath: IndexPath,
                        cellWidth: CGFloat) -> CGFloat {

        let item = contentItems[indexPath.item]
        let aspect = CGFloat(item.height) / CGFloat(item.width)
        return cellWidth * aspect + 40  
    }
}
