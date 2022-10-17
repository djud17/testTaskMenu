//
//  ApiService.swift
//  testTaskMenu
//
//  Created by Давид Тоноян  on 13.10.2022.
//

import Foundation
import Alamofire

enum ApiError: Error {
    case noData
    case wrongData
}

private enum ApiUrl: String {
    case allMenu = "https://burger-king-menu.p.rapidapi.com/categories"
    case allProducts = "https://burger-king-menu.p.rapidapi.com/products"
}

private enum ApiKey: String {
    case header = "X-RapidAPI-Key"
    case value = "466cd68c1cmsh01b76c38890b43dp1d7841jsnffd9eb7d1eeb"
}

private enum ApiHost: String {
    case header = "X-RapidAPI-Host"
    case value = "burger-king-menu.p.rapidapi.com"
}

protocol ApiClient {
    func getCategories(completion: @escaping (Result<[ProductCategory], ApiError>) -> Void)
    func getProductList(completion: @escaping (Result<[Product], ApiError>) -> Void)
}

final class ApiClientImpl: ApiClient {
    private let headers: HTTPHeaders = [
        ApiKey.header.rawValue: ApiKey.value.rawValue,
        ApiHost.header.rawValue: ApiHost.value.rawValue
    ]
    
    func getCategories(completion: @escaping (Result<[ProductCategory], ApiError>) -> Void) {
        let reqUrl = URL(string: ApiUrl.allMenu.rawValue)
        if let url = reqUrl {
            AF.request(url, headers: headers).responseData { response in
                if let data = response.value,
                   let response = response.response {
                    let categories: [ProductCategory]? = try? JSONDecoder().decode([ProductCategory].self, from: data)
                    if let categories = categories {
                        if (200...299).contains(response.statusCode) {
                            completion(.success(categories))
                        } else {
                            completion(.failure(ApiError.wrongData))
                        }
                    }
                } else {
                    completion(.failure(ApiError.noData))
                }
            }
        }
    }
    
    func getProductList(completion: @escaping (Result<[Product], ApiError>) -> Void) {
        let reqUrl = URL(string: ApiUrl.allProducts.rawValue)
        if let url = reqUrl {
            AF.request(url, headers: headers).responseData { response in
                if let data = response.value,
                   let response = response.response {
                    let products: [Product]? = try? JSONDecoder().decode([Product].self, from: data)
                    if let products = products {
                        if (200...299).contains(response.statusCode) {
                            completion(.success(products))
                        } else {
                            completion(.failure(ApiError.wrongData))
                        }
                    }
                } else {
                    completion(.failure(ApiError.noData))
                }
            }
        }
    }
}
