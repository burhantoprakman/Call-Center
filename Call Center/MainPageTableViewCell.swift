//
//  MainPageTableViewCell.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 29/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
class MainPageTableViewCell : UITableViewCell {
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newSummary: UILabel!
    
    func setArray(mdataset : MainPagePojo){
        
        newsTitle.text = mdataset.title
        newSummary.text = mdataset.summary
    }
    
}
