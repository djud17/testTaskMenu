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
    private let advertBackView = UIView()
    private var advertCollectionView: UICollectionView!
    
    private let filtersBackView = UIView()
    private var filtersCollectionView: UICollectionView!
    private var selectedFilterId = 1
    
    private let menuTableView = UITableView()
    
    private let apiClient: ApiClient = ApiClientImpl()
    var productCategories: [ProductCategory]? {
        didSet {
            productCategories?.sort {$0.id < $1.id}
        }
    }
    var productsFromJson: [Product]? {
        didSet {
            parseProducts()
            menuTableView.reloadData()
        }
    }
    var parsedAllProducts = [[Product]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
    }
    
    private func loadData() {
        DispatchQueue.main.async {
            self.apiClient.getCategories { result in
                switch result {
                case .failure(let error):
                    self.productCategories = []
                    print(error)
                case .success(let categories):
                    self.productCategories = categories
                }
                self.filtersCollectionView.reloadData()
            }
            self.apiClient.getProductList { result in
                switch result {
                case .failure(let error):
                    self.productsFromJson = []
                    print(error)
                case .success(let products):
                    self.productsFromJson = products
                }
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
        advertBackView.backgroundColor = .white
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
        filtersBackView.backgroundColor = .white
        view.addSubview(filtersBackView)
        
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
        let selectedIndex = selectedFilterId - 1
        let indexForTableView = IndexPath(row: 0, section: selectedIndex)
        let indexForCollectionView = IndexPath(row: selectedIndex, section: 0)
        
        filtersCollectionView.reloadData()
        filtersCollectionView.scrollToItem(at: indexForCollectionView,
                                           at: .centeredHorizontally,
                                           animated: true)
        menuTableView.scrollToRow(at: indexForTableView, at: .top, animated: true)
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
    
    private func parseProducts() {
        if let productCategories = productCategories {
            parsedAllProducts.removeAll()
            for section in 0..<productCategories.count {
                let filteredArr = productsFromJson?.filter { product in
                    var category: Int = 0
                    switch product.categoryID {
                    case .integerArray(let array):
                        category = array.first ?? 0
                    default:
                        break
                    }
                    return category == (section + 1)
                }
                parsedAllProducts.append([Product]())
                filteredArr?.forEach { parsedAllProducts[section].append($0) }
            }
        }
    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == advertCollectionView ? 3 : productCategories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == advertCollectionView,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advertCell",
                                                         for: indexPath) as? AdvertCollectionViewCell {
            cell.imageView.image = UIImage(named: "advert")
            return cell
        } else if collectionView == filtersCollectionView,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell",
                                                                for: indexPath) as? FilterCollectionViewCell {
            if let model = productCategories?[indexPath.row] {
                cell.filterButton.setTitle(model.name, for: .normal)
                cell.filterButton.tag = model.id
                cell.filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
                setButtonColor(cell.filterButton)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        parsedAllProducts[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        productCategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        productCategories?[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? CustomTableViewCell
        if productsFromJson != nil {
            let model = parsedAllProducts[indexPath.section][indexPath.row]
            let photoUrl = URL(string: model.image)
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
            var modelName = ""
            switch model.name {
            case .string(let name):
                modelName = name
            default:
                break
            }
            cell?.titleLabel.text = modelName
            cell?.descriptionLabel.text = model.productDescription
        }
        return cell ?? UITableViewCell()
    }
}
