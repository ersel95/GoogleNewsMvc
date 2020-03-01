//
//  requestNews.swift
//  GoogleNewsMvc
//
//  Created by Mr. T. on 29.02.2020.
//  Copyright © 2020 Mr. T. All rights reserved.
//

import Foundation

class RequestNews {
        
    static func getDatas(completion: @escaping(Bool?, Articles?,Int?, Error?) -> Void){
        guard let url = URL(string: API.Feed.usApi) else { return }
                
                URLSession.shared.dataTask(with: url) { (data, response, err) in
                    guard let data = data else { return }
                    do {
                        let articles = try JSONDecoder().decode(Articles.self, from: data)
                        let count = articles.articles.count
                        print(articles.articles)
                        completion(true,articles,count , nil)
                    } catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                        completion(false, nil, nil, jsonErr)
                    }
                }.resume()
    }
}
