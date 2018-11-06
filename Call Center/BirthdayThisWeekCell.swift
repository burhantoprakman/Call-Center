//
//  BirthdayThisWeek.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 29/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import Haneke
class BirthdayThisWeekCell : UITableViewCell {
    @IBOutlet weak var profilImage: UIImageView!
  
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var faceButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tebrikButton: UIButton!
    @IBOutlet weak var totalLikesLabel: UILabel!
    var delegate: BirthdayWeekCellDelegate?
    
    
    var userid : String = ""
    var totallike : Int = 0

    
    func setArray(mdataset : BirthdayPojo){
        self.profilImage.layer.cornerRadius = self.profilImage.frame.size.width / 2;
        self.profilImage.clipsToBounds = true;
        
        let defaults = UserDefaults.standard
        userid = defaults.string(forKey: "userid")!
        totallike = defaults.integer(forKey: "birthdaylikes")
        
        //User Birthday!!
        if(userid == mdataset.tebrikButton){
            tebrikButton.isHidden = true
            totalLikesLabel.isHidden = false
            totalLikesLabel.text = "\(totallike) kişi seni tebrik etti"
        }
        else if mdataset.isBeforeLiked == true {
            tebrikButton.isHidden = true
             totalLikesLabel.isHidden = false
            totalLikesLabel.text = "Daha önce tebrik ettiniz"
        } else {
            tebrikButton.isHidden = false
            totalLikesLabel.isHidden = true
        }
        
        
        
        let imgURL = mdataset.profImage
        let url = URL(string : imgURL)!
        self.profilImage.hnk_setImageFromURL(url)
        if(mdataset.instaString == "" || mdataset.instaString == nil || mdataset.instaString == "<null>"){
            instaButton.isHidden = true
        }else {
            instaButton.isHidden = false
            instaButton.titleLabel?.text = mdataset.instaString
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
    @IBAction func tebrikClicked(_ sender: Any) {
         delegate?.tebrikButtonClicked(self)
        tebrikButton.setTitle("Tebrik Edildi", for: .normal)
        tebrikButton.isEnabled = false
    }
    
    @IBAction func instaClicked(_ sender: Any) {
        delegate?.instaButtonClicked(self)
    }
    @IBAction func faceClicked(_ sender: Any) {
        delegate?.faceButtonClicked(self)
    }
}

protocol BirthdayWeekCellDelegate {
    func tebrikButtonClicked( _ cell : BirthdayThisWeekCell)
    func instaButtonClicked( _ cell : BirthdayThisWeekCell)
    func faceButtonClicked( _ cell : BirthdayThisWeekCell)
}

