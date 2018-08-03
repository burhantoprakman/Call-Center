//
//  MainPagePojo.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 29/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
class MainPagePojo {
    var imageUrl : String!
    var title : String!
    var summary : String!
    var newsId : Int!
    var newsDate : String!
    
    init(imageUrl : String,title : String , summary: String , newsId : Int, newsDate : String) {
        self.imageUrl = imageUrl
        self.title = title
        self.summary = summary
        self.newsId = newsId
        self.newsDate = newsDate
    }

}
