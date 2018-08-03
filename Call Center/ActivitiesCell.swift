//
//  ActivitiesCell.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 05/02/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit

class ActivitiesCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func setArray(mdataset : ActivitiesPojo){
        
    
        titleLabel.text = mdataset.activityTitle
        detailLabel.text = mdataset.activityDetail
        placeLabel.text = mdataset.place
        dateLabel.text = mdataset.date
        
    }
}
