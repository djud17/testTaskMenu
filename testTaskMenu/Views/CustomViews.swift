//
//  CustomViews.swift
//  testTaskMenu
//
//  Created by Давид Тоноян  on 14.10.2022.
//

import UIKit
import SnapKit

final class CustomCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.frame.size = CGSize(width: 300, height: 120)
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        addSubview(imageView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 10
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(5)
            make.trailing.bottom.equalToSuperview().inset(5)
        }
    }
}
