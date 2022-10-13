//
//  ViewController.swift
//  testTaskMenu
//
//  Created by Давид Тоноян  on 13.10.2022.
//

import UIKit
import SnapKit
import Kingfisher

final class MenuViewController: UIViewController {
    private var menuTableView: UITableView = {
        return UITableView()
    }()
    private var advertBackView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private var advertCollectionView: UICollectionView!
    private let apiClient: ApiClient = ApiClientImpl()
    var productCategories: [ProductCategory]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        //loadData()
    }
    
    private func loadData() {
        apiClient.getCategories { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.productCategories = []
                    print(error)
                case .success(let categories):
                    self.productCategories = categories
                }
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        setupAdvertBlock()
    }
    
    private func setupAdvertBlock() {
        view.addSubview(advertBackView)
        advertBackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 300, height: 120)
        layout.scrollDirection = .horizontal
        
        advertCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        advertCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "advertCell")
        advertCollectionView.backgroundColor = .white
        advertCollectionView.alwaysBounceHorizontal = true
        advertCollectionView.dataSource = self
        
        advertBackView.addSubview(advertCollectionView)
        
        advertCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func setupTableView() {
        
    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advertCell",
                                                      for: indexPath) as? CustomCollectionViewCell
        cell?.imageView.image = UIImage(named: "advert")
        return cell ?? UICollectionViewCell()
    }
}
