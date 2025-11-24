//
//  CategoryCell.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 21/11/25.
//

import UIKit
import SnapKit

class CategoryCell: UICollectionViewCell {
    static let reuseId = "CategoryCell"

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let indicatorView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 1.5
        v.isHidden = true
        v.backgroundColor = .white
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(indicatorView)
        
        makeConstarints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    func makeConstarints() {
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
        }

        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.width.equalTo(titleLabel)
            make.height.equalTo(2)
        }
    }

    
    override var isSelected: Bool {
        didSet { updateAppearance() }
    }
    
    func configure(with title: String, selectedColor: UIColor = .white) {
        titleLabel.text = title
        indicatorView.backgroundColor = selectedColor
        updateAppearance()
    }
    
    private func updateAppearance() {
        titleLabel.textColor = isSelected ? .white : .label
        titleLabel.font = isSelected ? UIFont.systemFont(ofSize: 15, weight: .semibold) : UIFont.systemFont(ofSize: 15, weight: .regular)
        indicatorView.isHidden = !isSelected
    }
    
}

