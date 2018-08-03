//
//  AllTransportCell.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 14/03/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit

class AllTransportCell: UITableViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var wayLink: UIButton!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverPhone: UILabel!
    @IBOutlet weak var carPlate: UILabel!
    var delegate: AllTransportDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setArray(mdataset : TransportPojo){
        self.serviceName.text = mdataset.serviceName
        self.driverName.text = mdataset.driverName
        self.driverPhone.text = mdataset.driverPhone
        self.carPlate.text = mdataset.carPlate
        wayLink.setTitle("\(mdataset.wayLink)", for: .normal)
        
    }
    @IBAction func wayLinkClicked(_ sender: Any) {
              delegate?.wayLinkClicked(self)
    }
    
}
protocol AllTransportDelegate {
    func wayLinkClicked( _ cell : AllTransportCell)
}

