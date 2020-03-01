//
//  NewsModel.swift
//  GoogleNewsMvc
//
//  Created by Mr. T. on 29.02.2020.
//  Copyright © 2020 Mr. T. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Articles : Codable {
    let articles: [News]
    let totalArticles : Int?

}

struct News: Codable{
    var source : Source?
    var title : String?
    var description : String?
    var urlToImage : String?
    var url: String?
}

struct Source: Codable {
    let id : String?
    let name : String?
}


