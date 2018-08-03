//
//  PersonalPojo.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 26/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
class PersonalPojo{
    var profilImage : String!
    var firmName : String!
    var nameSurname : String!
    var id : String!
    var email : String!
    var instaString : String!
    var faceString : String!
    
    init(profilImage : String, firmName : String, nameSurname : String, id: String, email : String , instaString : String, faceString : String) {
        self.profilImage = profilImage
        self.firmName = firmName
        self.nameSurname = nameSurname
        self.id = id
        self.email = email
        self.instaString = instaString
        self.faceString = faceString
    }
    
}
