//
//  FavoriteViewController.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 19/11/25.
//

import UIKit
import SnapKit

class FavoriteViewController: UIViewController {

    // MARK: - Properties
    private var favoriteItems: [UnsplashPhotoResponse] = []

    // MARK: - UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .black
        collection.isHidden = true
        return collection
    }()

    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "No favourites"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let emptySubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your favourite translations will appear here"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureNavigationBar()
        setupUI()
        makeConstraints()
        updateUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(emptyTitleLabel)
        view.addSubview(emptySubtitleLabel)
    }

    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }

        emptySubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyTitleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }

    private func updateUI() {
        if favoriteItems.isEmpty {
            collectionView.isHidden = true
            emptyTitleLabel.isHidden = false
            emptySubtitleLabel.isHidden = false
        } else {
            collectionView.isHidden = false
            emptyTitleLabel.isHidden = true
            emptySubtitleLabel.isHidden = true
            collectionView.reloadData()
        }
    }

    // MARK: - Navigation Bar
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCollectionViewCell
        cell.content = favoriteItems[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = width * 0.75 + 60
        return CGSize(width: width, height: height)
    }
}
