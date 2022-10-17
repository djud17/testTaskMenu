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
    private var advertBackView: UIView!
    private var advertCollectionView: UICollectionView!
    
    private var filtersBackView: UIView!
    private var filtersCollectionView: UICollectionView!
    private var selectedFilterId = 1
    
    private var menuTableView: UITableView!
    
    private let apiClient: ApiClient = ApiClientImpl()
    private let viewConfigurator = ViewConfigurator.shared
    
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
        advertBackView = viewConfigurator.setupAdvertBackView(view)
        advertCollectionView = viewConfigurator.setupAdvertCollectionView(advertBackView)
        advertCollectionView.dataSource = self
    }
    
    private func setupFiltersView() {
        filtersBackView = viewConfigurator.setupFiltersBackView(view, under: advertBackView)
        filtersCollectionView = viewConfigurator.setupFiltersCollectionView(filtersBackView)
        filtersCollectionView.dataSource = self
    }
    
    private func setupTableView() {
        menuTableView = viewConfigurator.setupTableView(view, under: filtersBackView)
        menuTableView.dataSource = self
        menuTableView.delegate = self
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
        if menuTableView.numberOfSections > 0 {
            menuTableView.scrollToRow(at: indexForTableView, at: .top, animated: true)
        }
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
