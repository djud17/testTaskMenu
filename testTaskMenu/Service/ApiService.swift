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
    case value = "466cd68c1cmsh01b76c38890b43dp1d7841jsnffd9eb7d1eeb"
}

private enum ApiHost: String {
    case header = "X-RapidAPI-Host"
    case value = "burger-king-menu.p.rapidapi.com"
}

protocol ApiClient {
    func getCategories(completion: @escaping (Result<[ProductCategory], ApiError>) -> Void)
}

final class ApiClientImpl: ApiClient {
    private let reqUrl = URL(string: ApiUrl.allMenu.rawValue)!
    private let headers: HTTPHeaders = [
        ApiKey.header.rawValue: ApiKey.value.rawValue,
        ApiHost.header.rawValue: ApiHost.value.rawValue
    ]
    
    func getCategories(completion: @escaping (Result<[ProductCategory], ApiError>) -> Void) {
        AF.request(reqUrl, headers: headers).responseData { response in
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
