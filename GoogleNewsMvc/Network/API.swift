//
//  API.swift
//  GoogleNewsMvc
//
//  Created by Mr. T. on 29.02.2020.
//  Copyright © 2020 Mr. T. All rights reserved.
//

import Foundation
import Alamofire

enum API {
    fileprivate static let baseURL = "http://newsapi.org/v2/top-headlines?country=us&apiKey=8bc26eecbc7b4f15bd099aa40411f7a8"
    
    enum Feed {
        // Google News Api
        static let usApi = baseURL
    }
}

class APIConnection {
    
    static func startRequest(url: String, parameters: [String: Any], method: HTTPMethod,avatar: String = "avatar", completion: @escaping (Any?, Error?) -> Void) {
        
        var header: HTTPHeaders?
        
        header = ["":""]
        
            /// -> Standart request
            AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                print("response:result", (response.result))
                switch response.result {
                case .success(let result):
                    completion((result as? Any)!, nil)
                case .failure(let error):
                    print("hata bu: \(error)", header as Any, url, parameters, method)
                    completion(nil,error)
                }
            }
    }
}
