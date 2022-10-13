//
//  ViewController.swift
//  testTaskMenu
//
//  Created by Давид Тоноян  on 13.10.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let request = NSMutableURLRequest(url: NSURL(string: reqUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("OK")
                print(httpResponse)
            }
        })

        dataTask.resume()
    }

    let reqUrl = "https://burger-king-menu.p.rapidapi.com/categories"

    let headers = [
        "X-RapidAPI-Key": "SIGN-UP-FOR-KEY",
        "X-RapidAPI-Host": "burger-king-menu.p.rapidapi.com"
    ]
}

