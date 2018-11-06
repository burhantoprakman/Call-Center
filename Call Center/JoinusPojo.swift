//
//  JoinusPojo.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 02/02/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
class JoinusPojo {
    var profImage : String
    var name : String
    var tebrikButton : String
    var phonenumber : String
    var email : String
    var firmName : String
    var instalink : String
    var facelink : String
    var isBeforeLiked : Bool
    
    init(profImage : String , name : String , tebrikButton : String , phonenumber : String, email : String, firmName : String, instalink : String, facelink : String,isBeforeLiked : Bool) {
        self.profImage = profImage
        self.name = name
        self.tebrikButton = tebrikButton
        self.phonenumber = phonenumber
        self.email = email
        self.firmName = firmName
        self.instalink = instalink
        self.facelink = facelink
        self.isBeforeLiked = isBeforeLiked
    }
    
    
}
