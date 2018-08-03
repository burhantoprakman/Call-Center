//
//  BirthdayToday.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 29/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import Haneke
class BirthdayTodayCell : UITableViewCell {
    @IBOutlet weak var profImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tebrikButton: UIButton!
    @IBOutlet weak var insstaButton: UIButton!
    @IBOutlet weak var faceButton: UIButton!
    
    
    var userid : String = ""
     var totallike : Int = 0
    var delegate: BirthdayCellDelegate?
    
    @IBOutlet weak var totalLikesLabel: UILabel!
    
    func setArray(mdataset : BirthdayPojo){
        let defaults = UserDefaults.standard
        userid = defaults.string(forKey: "userid")!
        totallike = defaults.integer(forKey: "birthdaylikes")
        
        //User Birthday!!
        if(userid == mdataset.tebrikButton){
            tebrikButton.isHidden = true
            totalLikesLabel.isHidden = false
            totalLikesLabel.text = "\(totallike)"
        }
        else {
            tebrikButton.isHidden = false
            totalLikesLabel.isHidden = true
        }
        
        self.profImage.layer.cornerRadius = self.profImage.frame.size.width / 2;
        self.profImage.clipsToBounds = true;
        let imgURL = mdataset.profImage
        let url = URL(string : imgURL)!
        self.profImage.hnk_setImageFromURL(url)
      
        if(mdataset.instaString == "" || mdataset.instaString == nil || mdataset.instaString == "<null>"){
            insstaButton.isHidden = true
        }else {
            insstaButton.isHidden = false
            insstaButton.titleLabel?.text = mdataset.instaString
        }
        if(mdataset.faceString == "" || mdataset.faceString == nil || mdataset.faceString == "<null>"){
            faceButton.isHidden = true
        }else {
            faceButton.isHidden = false
            faceButton.titleLabel?.text = mdataset.faceString
        }
        
        
        
        
        nameLabel.text = mdataset.name
        tebrikButton.tag = Int(mdataset.tebrikButton)!

    }
    
    @IBAction func instaClicked(_ sender: Any) {
        delegate?.instaButtonClicked(self)
    }
    @IBAction func faceClicked(_ sender: Any) {
        delegate?.faceButtonClicked(self)
    }
    
    @IBAction func tebrikClicked(_ sender: Any) {
        delegate?.tebrikButtonClicked(self)
        tebrikButton.setTitle("Tebrik Edildi", for: .normal)
        tebrikButton.isEnabled = false
    }
    
}
protocol BirthdayCellDelegate {
    func tebrikButtonClicked( _ cell : BirthdayTodayCell)
    func instaButtonClicked( _ cell : BirthdayTodayCell)
    func faceButtonClicked( _ cell : BirthdayTodayCell)
}
