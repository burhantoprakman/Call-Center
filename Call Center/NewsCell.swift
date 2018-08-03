//
//  NewsCell.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 01/03/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    
    func setArray(mdataset : MainPagePojo){
        let imageUrl = mdataset.imageUrl
        newsImage.setImageFromURl(stringImageUrl: imageUrl!)
        newsTitle.text = mdataset.title
        newsDate.text = mdataset.newsDate
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
