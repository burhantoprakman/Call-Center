//
//  YourTransportCellTableViewCell.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 13/03/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit

class YourTransportCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var wayLinkButton: UIButton!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverPhoneLabel: UILabel!
    @IBOutlet weak var plateNumberLabel: UILabel!
    var delegate: YourTransportCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func wayLinkClicked(_ sender: Any) {
        delegate?.wayLinkClicked(self)
    }
    func setArray(mdataset : TransportPojo){
        self.serviceNameLabel.text = mdataset.serviceName
        self.driverNameLabel.text = mdataset.driverName
        self.driverPhoneLabel.text = mdataset.driverPhone
        self.plateNumberLabel.text = mdataset.carPlate
        wayLinkButton.setTitle("\(mdataset.wayLink)", for: .normal)
        
    }
    
}
protocol YourTransportCellDelegate {
    func wayLinkClicked( _ cell : YourTransportCellTableViewCell)

}
