//
//  TransportHeaderPojo.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 13/03/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//
import Foundation
import UIKit

class TransportHeaderPojo {
    var headerName : String
    var collapsed : Bool
    var items : [TransportPojo]
    
    init(headerName : String, items : [TransportPojo], collapsed : Bool = false) {
        self.headerName = headerName
        self.items = items
        self.collapsed = collapsed
    }
    
}
