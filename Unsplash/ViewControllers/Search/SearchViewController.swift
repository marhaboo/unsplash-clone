//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 19/11/25.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    // MARK: Properties
    private var discoverItems: [UnsplashPhotoResponse] = []
    private var categories = ["Nature", "Black and White", "Space", "Animals", "Flowers", "Underwater", "Architecture", "Textures", "Abstract", "Minimal", "Sky", "Travel", "Drones", "Gradients"]

    // MARK: UI
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search photos, collections, users"
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        search.setImage(image, for: .search, state: .normal)
        let tf = search.searchTextField
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        return search
    }()
    
    private let categoryScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()

    
    private let categoryStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let discoverCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .black
        collection.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCell")
        return collection
    }()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        scrollView.contentInsetAdjustmentBehavior = .never

        setupViews()
        setupCategories()
        setupCollectionView()
        fetchDiscoverPhotos()
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
}
        
        
        scrollView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(58)
            make.width.equalToSuperview()
        }
        
        contentStack.addArrangedSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        let browseLabel = UILabel()
        browseLabel.text = "Browse by Category"
        browseLabel.font = .boldSystemFont(ofSize: 22)
        browseLabel.textColor = .white
        contentStack.addArrangedSubview(browseLabel)
        
        contentStack.addArrangedSubview(categoryScrollView)
        categoryScrollView.snp.makeConstraints { make in
            make.height.equalTo(220)
        }

    
        categoryScrollView.addSubview(categoryStack)
        categoryStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            
  
            let totalWidth = (CGFloat(categories.count)/2) * 110 + CGFloat(categories.count/2 - 1) * 8
            categoryStack.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalToSuperview()
                make.width.equalTo(totalWidth)
            }

        }

        
        let discoverLabel = UILabel()
        discoverLabel.text = "Discover"
        discoverLabel.font = .boldSystemFont(ofSize: 22)
        discoverLabel.textColor = .white
        contentStack.addArrangedSubview(discoverLabel)
        
        contentStack.addArrangedSubview(discoverCollectionView)
        discoverCollectionView.snp.makeConstraints { make in
            make.height.equalTo(400)
        }
    }
    
    private func setupCategories() {
        let row1 = UIStackView()
        row1.axis = .horizontal
        row1.spacing = 8
        row1.distribution = .fill
        row1.alignment = .top

        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.spacing = 8
        row2.distribution = .fill
        row2.alignment = .top

        for (index, cat) in categories.enumerated() {
            let view = UIView()
            view.layer.cornerRadius = 8
            view.clipsToBounds = true
            
         
            let imageView = UIImageView()
            imageView.image = UIImage(named: "nature")
            imageView.contentMode = .scaleAspectFill
            view.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

  
            let label = UILabel()
            label.text = cat
            label.textColor = .white
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 16, weight: .medium)
            label.numberOfLines = 0
            label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            view.snp.makeConstraints { make in
                make.width.height.equalTo(110)
            }

            if index < (categories.count + 1) / 2 {
                row1.addArrangedSubview(view)
            } else {
                row2.addArrangedSubview(view)
            }
        }

        categoryStack.addArrangedSubview(row1)
        categoryStack.addArrangedSubview(row2)
        categoryStack.alignment = .leading
    }

    
    private func setupCollectionView() {
        discoverCollectionView.dataSource = self
        discoverCollectionView.delegate = self
    }
    
    private func fetchDiscoverPhotos() {
        NetworkManager.getEditorialPhotos { result in
            switch result {
            case .success(let photos):
                self.discoverItems = photos
                DispatchQueue.main.async {
                    self.discoverCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discoverItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCollectionViewCell
        cell.content = discoverItems[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = discoverItems[indexPath.item]
        let width = (collectionView.bounds.width - 2) / 2
        let height = width * CGFloat(photo.height) / CGFloat(photo.width)
        return CGSize(width: width, height: height)
    }
}
