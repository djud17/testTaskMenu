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
    private var advertBackView: UIView = {
        let view = UIView()
        return view
    }()
    private var advertCollectionView: UICollectionView!
    
    private var filtersBackView: UIView = {
        let view = UIView()
        return view
    }()
    private var filtersCollectionView: UICollectionView!
    private var selectedFilterId = 1
    
    private var menuTableView: UITableView = {
        let tableVIew = UITableView()
        return tableVIew
    }()
    
    private let apiClient: ApiClient = ApiClientImpl()
    var productCategories: [ProductCategory]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
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
                self.menuTableView.reloadData()
                self.filtersCollectionView.reloadData()
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        setupAdvertBlock()
        setupFiltersView()
        setupTableView()
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
        advertCollectionView.register(AdvertCollectionViewCell.self, forCellWithReuseIdentifier: "advertCell")
        advertCollectionView.backgroundColor = .white
        advertCollectionView.alwaysBounceHorizontal = true
        advertCollectionView.dataSource = self
        
        advertBackView.addSubview(advertCollectionView)
        
        advertCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func setupFiltersView() {
        view.addSubview(filtersBackView)
        
        filtersBackView.backgroundColor = .white
        
        filtersBackView.snp.makeConstraints { make in
            make.top.equalTo(advertBackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 150, height: 40)
        layout.scrollDirection = .horizontal

        filtersCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        filtersCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "filterCell")
        filtersCollectionView.backgroundColor = .white
        filtersCollectionView.alwaysBounceHorizontal = true
        filtersCollectionView.dataSource = self

        filtersBackView.addSubview(filtersCollectionView)

        filtersCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func setupTableView() {
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "menuCell")
        menuTableView.backgroundColor = .white
        menuTableView.allowsSelection = false
        menuTableView.separatorColor = .white
        view.addSubview(menuTableView)
        
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(filtersBackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func filterButtonTapped(sender: UIButton) {
        selectedFilterId = sender.tag
        filtersCollectionView.reloadData()
    }
    
    private func setButtonColor(_ button: UIButton?) {
        if let button = button {
            let buttonColor = UIColor(red: 0.992, green: 0.227, blue: 0.412, alpha: 0.2)
            button.layer.borderColor = buttonColor.cgColor
            button.setTitleColor(buttonColor, for: .highlighted)
            
            if button.tag == selectedFilterId {
                button.backgroundColor = buttonColor
                button.setTitleColor(buttonColor.withAlphaComponent(1), for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(buttonColor, for: .normal)
            }
        }
    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == self.advertCollectionView ? 3 : productCategories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.advertCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advertCell",
                                                          for: indexPath) as? AdvertCollectionViewCell
            cell?.imageView.image = UIImage(named: "advert")
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell",
                                                          for: indexPath) as? FilterCollectionViewCell
            let model = productCategories?[indexPath.row]
            cell?.filterButton.setTitle(model?.name, for: .normal)
            cell?.filterButton.tag = model?.id ?? 0
            cell?.filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
            setButtonColor(cell?.filterButton)
            
            return cell ?? UICollectionViewCell()
        }
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productCategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? CustomTableViewCell
        if let categories = productCategories {
            let model = categories[indexPath.row]
            let photoUrl = URL(string: model.img)
            let processor = DownsamplingImageProcessor(size: cell?.productImageView.bounds.size ?? CGSize())
            |> RoundCornerImageProcessor(cornerRadius: 10)
            cell?.productImageView.kf.indicatorType = .activity
            cell?.productImageView.kf.setImage(
                with: photoUrl,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            cell?.titleLabel.text = model.name
            cell?.descriptionLabel.text = String(model.id)
        }
        return cell ?? UITableViewCell()
    }
}
