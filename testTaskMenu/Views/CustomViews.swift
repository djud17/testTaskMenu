//
//  CustomViews.swift
//  testTaskMenu
//
//  Created by Давид Тоноян  on 14.10.2022.
//

import UIKit
import SnapKit

private let lightRedColor = UIColor(red: 0.992, green: 0.227, blue: 0.412, alpha: 0.2)

final class AdvertCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.frame.size = CGSize(width: 300, height: 120)
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.borderColor = lightRedColor.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 10
        addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(5)
            make.trailing.bottom.equalToSuperview().inset(5)
        }
    }
}

final class FilterCollectionViewCell: UICollectionViewCell {
    let filterButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        filterButton.backgroundColor = lightRedColor
        filterButton.layer.borderColor = lightRedColor.cgColor
        filterButton.setTitleColor(lightRedColor.withAlphaComponent(1), for: .normal)
        filterButton.setTitleColor(lightRedColor, for: .highlighted)
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        addSubview(filterButton)
    }
    
    private func setupConstraints() {
        filterButton.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

final class CustomTableViewCell: UITableViewCell {
    private let backView: UIView = {
        let view = UIView()
        view.layer.borderColor = lightRedColor.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 10
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    let productImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.frame.size = CGSize(width: 80, height: 80)
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backView.addSubview(titleLabel)
        backView.addSubview(descriptionLabel)
        backView.addSubview(productImageView)
        addSubview(backView)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(5)
        }
        
        productImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(10)
            make.width.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.trailing.bottom.equalToSuperview()
        }
    }
}
