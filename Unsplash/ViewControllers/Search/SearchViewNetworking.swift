//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 25/11/25.
//

import UIKit 
import SnapKit

extension SearchViewController {

    func fetchTopics() {
        NetworkManager.getTopics { result in
            switch result {
            case .success(let topics):
                self.categoryItems = topics
                self.categories = topics.map { $0.title }
                DispatchQueue.main.async { self.setupCategories() }
            case .failure(let error):
                print("Error fetching topics:", error)
            }
        }
    }

    func fetchDiscoverPhotos() {
        NetworkManager.getEditorialPhotos { result in
            switch result {
            case .success(let photos):
                self.discoverItems = photos
                DispatchQueue.main.async { self.discoverCollectionView.reloadData() }
            case .failure(let error):
                print(error)
            }
        }
    }

    func searchPhotos(query: String) {
        NetworkManager.searchPhotos(query: query) { result in
            switch result {
            case .success(let photos):
                self.discoverItems = photos
                DispatchQueue.main.async { self.discoverCollectionView.reloadData() }
            case .failure(let error):
                print("Search error:", error)
            }
        }
    }
}


