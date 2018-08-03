//
//  JoinTodayCell.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 02/02/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import Haneke

class JoinTodayCell : UITableViewCell {
    
    @IBOutlet weak var porfilImage: UIImageView!
    @IBOutlet weak var firmLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tebrikButton: UIButton!
    @IBOutlet weak var totalLikesLabel: UILabel!
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var faceButton: UIButton!
    
    
    var totallike : Int = 0
    var userid : String = ""
    var delegate: JoinCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setArray(mdataset : JoinusPojo){
        self.porfilImage.layer.cornerRadius = self.porfilImage.frame.size.width / 2;
        self.porfilImage.clipsToBounds = true;
        
        let defaults = UserDefaults.standard
        userid = defaults.string(forKey: "userid")!
        totallike = defaults.integer(forKey: "joinlikes")
        
        //User Joins!!
        if(userid == mdataset.tebrikButton){
            tebrikButton.isHidden = true
            totalLikesLabel.isHidden = false
            totalLikesLabel.text = "\(totallike)"
        }
        else {
            tebrikButton.isHidden = false
            totalLikesLabel.isHidden = true
        }
        
        let imgURL = mdataset.profImage
        let url = URL(string : imgURL)!
        self.porfilImage.hnk_setImageFromURL(url)
        
        
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
protocol JoinCellDelegate {
    func tebrikButtonClicked( _ cell : JoinTodayCell)
    func instaButtonClicked( _ cell : JoinTodayCell)
    func faceButtonClicked( _ cell : JoinTodayCell)
}

