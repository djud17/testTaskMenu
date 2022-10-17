//
//  ViewConfigurator.swift
//  testTaskMenu
//
//  Created by Давид Тоноян  on 17.10.2022.
//

import UIKit

final class ViewConfigurator {
    static let shared = ViewConfigurator()
    
    func setupAdvertBackView(_ superview: UIView) -> UIView {
        let advertView = UIView()
        advertView.backgroundColor = .white
        superview.addSubview(advertView)
        advertView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        return advertView
    }
    
    func setupAdvertCollectionView(_ superview: UIView) -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 300, height: 120)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.register(AdvertCollectionViewCell.self, forCellWithReuseIdentifier: "advertCell")
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceHorizontal = true
        
        superview.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        return collectionView
    }
    
    func setupFiltersBackView(_ superview: UIView, under view: UIView) -> UIView {
        let filtersBackView = UIView()
        filtersBackView.backgroundColor = .white
        superview.addSubview(filtersBackView)
        
        filtersBackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        return filtersBackView
    }
    
    func setupFiltersCollectionView(_ superview: UIView) -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 150, height: 40)
        layout.scrollDirection = .horizontal

        let filtersCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        filtersCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "filterCell")
        filtersCollectionView.backgroundColor = .white
        filtersCollectionView.alwaysBounceHorizontal = true

        superview.addSubview(filtersCollectionView)

        filtersCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        return filtersCollectionView
    }
    
    func setupTableView(_ superview: UIView, under view: UIView) -> UITableView {
        let menuTableView = UITableView()
        menuTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "menuCell")
        menuTableView.backgroundColor = .white
        menuTableView.allowsSelection = false
        menuTableView.separatorColor = .white
        
        superview.addSubview(menuTableView)
        
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        return menuTableView
    }
}
