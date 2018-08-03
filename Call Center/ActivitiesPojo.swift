//
//  ActivitiesPojo.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 05/02/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
class ActivitiesPojo {
    var activityTitle : String
    var activityDetail : String
    var place : String
    var date : String
    
    init(activityTitle : String , activityDetail : String, place : String, date : String) {
        self.activityTitle = activityTitle
        self.activityDetail = activityDetail
        self.place = place
        self.date = date
    }
}
