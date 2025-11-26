//
//  TopicPhotosViewController.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 26/11/25.
//

import UIKit
import SnapKit

final class TopicPhotosViewController: UIViewController {
    
    // MARK: - Inputs
    private let topicTitle: String
    private let topicSlug: String
    
    // MARK: - Data
    private var items: [UnsplashPhotoResponse] = []
    private var isLoading = false
    private var page = 1
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        layout.numberOfColumns = 2
        layout.cellSpacing = 2
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.dataSource = self
        cv.delegate = self
        cv.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCell")
        return cv
    }()
    
    // MARK: - Init
    init(topicTitle: String, topicSlug: String) {
        self.topicTitle = topicTitle
        self.topicSlug = topicSlug
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavBar()
        setupViews()
        fetch(page: 1)
    }
    
    private func setupNavBar() {
        navigationItem.title = topicTitle
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                          .font: UIFont.boldSystemFont(ofSize: 22)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Networking
    private func fetch(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        NetworkManager.getTopicPhotos(slug: topicSlug, page: page, perPage: 30) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let photos):
                if page == 1 {
                    self.items = photos
                } else {
                    self.items.append(contentsOf: photos)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.page = page
            case .failure(let error):
                print("Topic photos error:", error)
            }
        }
    }
}

// MARK: - DataSource
extension TopicPhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCollectionViewCell
        cell.updateContent(items[indexPath.item])
        return cell
    }
}

// MARK: - PinterestLayoutDelegate
extension TopicPhotosViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAt indexPath: IndexPath,
                        cellWidth: CGFloat) -> CGFloat {
        let item = items[indexPath.item]
       
        let aspect = CGFloat(item.height) / CGFloat(item.width)
        return cellWidth * aspect
    }
}

// MARK: - UIScrollViewDelegate (pagination)
extension TopicPhotosViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let threshold = scrollView.contentSize.height - scrollView.bounds.height - 600
        if offsetY > threshold, !isLoading {
            fetch(page: page + 1)
        }
    }
}
