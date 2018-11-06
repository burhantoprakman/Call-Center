//
//  JoinThisMonthCell.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 02/02/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import Haneke

class JoinThisMonthCell : UITableViewCell {
    
    @IBOutlet weak var profilImage: UIImageView!
    @IBOutlet weak var firmLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tebrikButton: UIButton!
    @IBOutlet weak var totalLikesLabel: UILabel!
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var faceButton: UIButton!
    
    var totallike : Int = 0
    var userid : String = ""
    
    var delegate: JoinMonthCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setArray(mdataset : JoinusPojo){
        self.profilImage.layer.cornerRadius = self.profilImage.frame.size.width / 2;
        self.profilImage.clipsToBounds = true;
        
        let defaults = UserDefaults.standard
        userid = defaults.string(forKey: "userid")!
        totallike = defaults.integer(forKey: "joinlikes")
        
        //User Joins!!
        if(userid == mdataset.tebrikButton){
            tebrikButton.isHidden = true
            totalLikesLabel.isHidden = false
            totalLikesLabel.text = "\(totallike) kişi seni tebrik etti"
        }
        else  if mdataset.isBeforeLiked == true {
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
        
        
        nameLabel.text = mdataset.name
        tebrikButton.tag = Int(mdataset.tebrikButton)!
        
        if(mdataset.instalink == "" || mdataset.instalink == nil || mdataset.instalink == "<null>"){
            instaButton.isHidden = true
        }else {
            instaButton.isHidden = false
            instaButton.titleLabel?.text = mdataset.instalink
        }
        if(mdataset.facelink == "" || mdataset.facelink == nil || mdataset.facelink == "<null>"){
            faceButton.isHidden = true
        }else {
            faceButton.isHidden = false
            faceButton.titleLabel?.text = mdataset.facelink
        }
        emailLabel.text = mdataset.email
        firmLabel.text = mdataset.firmName
        
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
protocol JoinMonthCellDelegate {
    func tebrikButtonClicked( _ cell : JoinThisMonthCell)
    func instaButtonClicked( _ cell : JoinThisMonthCell)
    func faceButtonClicked( _ cell : JoinThisMonthCell)
}
