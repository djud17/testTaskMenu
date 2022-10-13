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
}

private enum ApiKey: String {
    case header = "X-RapidAPI-Key"
    case value = "SIGN-UP-FOR-KEY"
}

private enum ApiHost: String {
    case header = "X-RapidAPI-Host"
    case value = "burger-king-menu.p.rapidapi.com"
}

protocol ApiClient {
    func getCategories(completion: @escaping (Result<[ProductCategory], ApiError>) -> Void)
}

class ApiClientImpl: ApiClient {
    let reqUrl = URL(string: ApiUrl.allMenu.rawValue)!
    let headers = [
        ApiKey.header.rawValue: ApiKey.value.rawValue,
        ApiHost.header.rawValue: ApiHost.value.rawValue
    ]
    
    func getCategories(completion: @escaping (Result<[ProductCategory], ApiError>) -> Void) {
        AF.request(reqUrl).responseData { response in
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
