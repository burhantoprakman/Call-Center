//
//  TransportPojo.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 13/03/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit

class TransportPojo {

    var serviceName : String
    var driverName : String
    var driverPhone : String
    var carPlate : String
    var wayLink : String
    
    init(serviceName : String,driverName :String, driverPhone : String , carPlate : String, wayLink : String) {
        self.serviceName = serviceName
        self.driverName = driverName
        self.driverPhone = driverPhone
        self.carPlate = carPlate
        self.wayLink = wayLink
    }

}
