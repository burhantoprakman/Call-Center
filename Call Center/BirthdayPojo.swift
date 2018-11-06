//
//  BirthdayPojo.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 29/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
class BirthdayPojo {
    var profImage : String
    var name : String
    var tebrikButton : String
    var instaString : String
    var faceString : String
    var horoscope : String
    var isBeforeLiked : Bool
    //var totalLikes : String
    
    init(profImage : String , name : String , tebrikButton : String , instaString : String , faceString : String, horoscope : String,isBeforeLiked: Bool) {
        self.profImage = profImage
        self.name = name
        self.tebrikButton = tebrikButton
        self.instaString = instaString
        self.faceString = faceString
        self.horoscope = horoscope
        self.isBeforeLiked = isBeforeLiked
        //self.totalLikes = totalLikes
    }
    
    
}
