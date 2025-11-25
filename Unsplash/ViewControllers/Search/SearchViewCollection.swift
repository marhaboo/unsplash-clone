//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 25/11/25.
//


import UIKit

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func setupCollectionView() {
        discoverCollectionView.dataSource = self
        discoverCollectionView.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        discoverItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCollectionViewCell
        cell.updateContent(discoverItems[indexPath.item]) 
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = discoverItems[indexPath.item]
        let width = (collectionView.bounds.width - 2) / 2
        let height = width * CGFloat(photo.height)/CGFloat(photo.width)
        return CGSize(width: width, height: height)
    }
}
