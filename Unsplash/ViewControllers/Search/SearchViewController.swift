//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 25/11/25.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController, PinterestLayoutDelegate {

    // MARK: - Properties
    var discoverItems: [UnsplashPhotoResponse] = []
    var categoryItems: [UnsplashTopicResponse] = []
    var categories: [String] = []

    var recentSearches: [String] = ["wallpaper 4k"]
    var trendingSearches: [String] = ["thanksgiving", "winter", "gaming", "pants on fire", "beauty"]

    // MARK: - UI Elements
    let scrollView = UIScrollView()
    let contentStack = UIStackView()
    let searchBar = UISearchBar()
    let categoryScrollView = UIScrollView()
    let categoryStack = UIStackView()
    let discoverCollectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.numberOfColumns = 2
        layout.cellSpacing = 2
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .black
        collection.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCell")
        return collection
    }()
    let searchSuggestionsTableView = UITableView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        scrollView.contentInsetAdjustmentBehavior = .never
        searchBar.delegate = self

        setupViews()
        setupCollectionView()
        setupSearchSuggestions()
        fetchTopics()
        fetchDiscoverPhotos()
    }
    
}


