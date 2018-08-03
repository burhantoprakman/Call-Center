//
//  PersonalCell.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 26/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import Haneke

class PersonelCell : UITableViewCell{
    @IBOutlet weak var profilImage: UIImageView!
    @IBOutlet weak var firmNameLabel: UILabel!
    @IBOutlet weak var faceLinkButton: UIButton!
    @IBOutlet weak var instaLinkButton: UIButton!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    
    
    
    
    
    func setArray(mdataset : PersonalPojo){
        
        let imgURL = mdataset.profilImage
        let url = URL(string : imgURL!)!
        self.profilImage.hnk_setImageFromURL(url)
        firmNameLabel.text = mdataset.firmName
        faceLinkButton.isHidden = true
        instaLinkButton.isHidden = true
        faceLinkButton.titleLabel?.text = mdataset.faceString
        instaLinkButton.titleLabel?.text = mdataset.instaString
        idLabel.text = mdataset.id
        emailLabel.text = mdataset.email
        nameSurnameLabel.text = mdataset.nameSurname
        
     
    }
 
    
}
