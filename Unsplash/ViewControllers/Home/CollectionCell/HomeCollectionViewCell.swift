//
// HomeCollectionViewCell.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 19/11/25.
//

import UIKit
import SnapKit

final class HomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Data
    var content: UnsplashPhotoResponse? {
        didSet {
            guard let content = content else { return }
            
            if let url = URL(string: content.urls.small) {
                loadImage(from: url)
            } else {
                containerImageView.image = nil
            }
            
            titleLabel.text = content.user.name
            subTitleLabel.text = content.user.username
        }
    }
    
    func updateContent(_ photo: UnsplashPhotoResponse) {
        self.content = photo
    }
    
    // MARK: - UI Components
    private let containerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private var imageTask: URLSessionDataTask?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        containerImageView.image = nil
        titleLabel.text = nil
        subTitleLabel.text = nil
    }
    
    // MARK: - Image loading (
    private func loadImage(from url: URL) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        imageTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil,
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.containerImageView.image = image
            }
        }
        imageTask?.resume()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        contentView.addSubview(containerImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
    }
    
    private func setupConstraints() {
        containerImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerImageView.snp.bottom).inset(52)
            make.leading.equalToSuperview().offset(16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
        }
    }
}
