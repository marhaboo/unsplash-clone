//
//  SearchViewControllerCategories.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 25/11/25.
//

import UIKit
import SnapKit

extension SearchViewController {

    func buildCategoryGrid() {
        categoryStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let row1 = UIStackView()
        row1.axis = .horizontal
        row1.spacing = 8
        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.spacing = 8

        for (index, topic) in categoryItems.enumerated() {
            let container = UIView()
            container.layer.cornerRadius = 10
            container.clipsToBounds = true
            container.isUserInteractionEnabled = true
            container.tag = index

            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCategory(_:)))
            container.addGestureRecognizer(tap)

            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .darkGray
            container.addSubview(imageView)
            imageView.snp.makeConstraints { $0.edges.equalToSuperview() }

            if let urlString = topic.cover_photo?.urls.small, let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let img = UIImage(data: data) {
                        DispatchQueue.main.async { imageView.image = img }
                    }
                }.resume()
            }

            let label = UILabel()
            label.text = topic.title
            label.textColor = .white
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 16, weight: .semibold)
            label.backgroundColor = UIColor.black.withAlphaComponent(0.35)
            container.addSubview(label)
            label.snp.makeConstraints { $0.edges.equalToSuperview() }

            container.snp.makeConstraints { $0.width.height.equalTo(128) }

            if index < (categoryItems.count + 1) / 2 {
                row1.addArrangedSubview(container)
            } else {
                row2.addArrangedSubview(container)
            }
        }

        categoryStack.addArrangedSubview(row1)
        categoryStack.addArrangedSubview(row2)
    }

    @objc private func didTapCategory(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let index = view.tag
        guard categoryItems.indices.contains(index) else { return }
        let topic = categoryItems[index]

        let vc = TopicPhotosViewController(topicTitle: topic.title, topicSlug: topic.slug)
        navigationController?.pushViewController(vc, animated: true)
    }
}

