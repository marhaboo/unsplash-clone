//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 25/11/25.
//

import UIKit
import SnapKit

extension SearchViewController {

    func setupViews() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }

        scrollView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(58)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        setupSearchBar()
        setupCategorySection()
        setupDiscoverSection()
    }

    func setupSearchBar() {
        searchBar.placeholder = "Search photos, collections, users"
        contentStack.addArrangedSubview(searchBar)
        searchBar.snp.makeConstraints { $0.height.equalTo(50) }
    }

    func setupCategorySection() {
        let label = UILabel()
        label.text = "Browse by Category"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .white
        contentStack.addArrangedSubview(label)

        contentStack.addArrangedSubview(categoryScrollView)
        categoryScrollView.showsHorizontalScrollIndicator = false
        categoryScrollView.snp.makeConstraints { $0.height.equalTo(220) }

        categoryScrollView.addSubview(categoryStack)
        categoryStack.axis = .vertical
        categoryStack.spacing = 8
        categoryStack.distribution = .fillEqually
        categoryStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }

    func setupDiscoverSection() {
        let label = UILabel()
        label.text = "Discover"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .white
        contentStack.addArrangedSubview(label)

        contentStack.addArrangedSubview(discoverCollectionView)
        discoverCollectionView.snp.makeConstraints { $0.height.equalTo(400) }
    }
}

