//
//  YourTranssport.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 07/02/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class YourTransportVC: UIViewController, IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var yourTransportTableView: UITableView!
    @IBOutlet weak var yourAdressLabel: UILabel!
    
    var tYourResult = [TransportHeaderPojo]()

    var autoid : String = ""
    var firebaseToken : String = ""
    var userid : String = ""
    var wayLinkValue : String = ""
    var headerTag : String = ""
    var rowTag : String = ""
    var rowValue : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yourTransportTableView.delegate = self
        yourTransportTableView.dataSource = self
        
        
        let defaults = UserDefaults.standard
        autoid = defaults.string(forKey: "autoid")!
        firebaseToken = defaults.string(forKey: "firebasetoken")!
        userid = defaults.string(forKey: "userid")!
        
       
        yourTransportTableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
        
        getyourTransport()
    }
    func getyourTransport(){
        var resultArray  = [TransportHeaderPojo]()
        let url = URL(string: "https://ekolife.ekoccs.com/api/User/GetTransportation?userId=\(userid)")!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let together = "\(autoid) \(firebaseToken)"
        config.httpAdditionalHeaders = ["Authorization" : together]
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
            
            do {
                let JsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                DispatchQueue.main.async {
                    
                    let totalarray : [Any]!  = JsonResult["Servisler"] as! [Any]
                    let avenue = JsonResult["StCadde"] as! String
                    let street = JsonResult["StSokak"] as! String
                    let town = JsonResult["stMahalle"] as! String
                    let discrit = JsonResult["StIlce"] as! String
                    
                    for i in 0 ..< totalarray.count  {
                        var transportArray : [TransportPojo] = []
                        let users = totalarray[i] as! [String : AnyObject]
                        let vardiya : String = String(describing: users["StSaat"]!)
                        let service : String = String(describing: users["StServis"]!)
                        let driverName : String = String(describing: users["StSurucuAdi"]!)
                        let driverPhone : String = String(describing: users["StSurucuGSM"]!)
                        let servicePlate : String = String(describing: users["StServisPlaka"]!)
                        let wayLink : String = String(describing: users["StGuzergahLink"]!)
                        
                        let transportpojo = TransportPojo.init(serviceName: service, driverName: driverName, driverPhone: driverPhone, carPlate: servicePlate, wayLink: wayLink)
                       transportArray.append(transportpojo)
                        let tYourPojo = TransportHeaderPojo.init(headerName: vardiya, items: transportArray, collapsed: true)
                        resultArray.append(tYourPojo)
                    }
                    self.yourAdressLabel.text = "\(avenue) \(street) \(town) \(discrit)"
                    
                }
                DispatchQueue.main.async {
                    self.tYourResult = resultArray
                    
                    self.yourTransportTableView.reloadData()
                }
                
                
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return tYourResult.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tYourResult[section].collapsed ? 0 : 1
    }
   
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: YourTransportCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "yourtransportcell") as? YourTransportCellTableViewCell ??
            YourTransportCellTableViewCell(style: .default, reuseIdentifier: "yourtransportcell")
        
        let item : TransportPojo = tYourResult[indexPath.section].items[indexPath.row]
    
        cell.setArray(mdataset: item)
        headerTag = "\(indexPath.section)"
        rowTag = "\(indexPath.row)"
        cell.wayLinkButton.tag = Int(headerTag+rowTag)!
        cell.wayLinkButton.addTarget(self, action: #selector(wayLinkButton(sender:)), for: .touchUpInside )
    
        
        return cell
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = tYourResult[section].headerName
        header.arrowLabel.image = #imageLiteral(resourceName: "okasagi.png")
        header.setCollapsed(tYourResult[section].collapsed)
        
        header.section = section
        header.delegate = self as CollapsibleTableViewHeaderDelegate
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func wayLinkButton(sender: UIButton){
        let arrayofstring = Array("\(sender.tag)" .characters)
        let headerValue = Int(String(arrayofstring[0]))
        if(arrayofstring.count == 3){
            rowValue = Int(String(arrayofstring[1])+String(arrayofstring[2]))!
        }
        else{
            rowValue = Int(String(arrayofstring[1]))!
        }
        wayLinkValue =  tYourResult[headerValue!].items[rowValue].wayLink
        print(wayLinkValue)
        openWayLink()
        
    }
    func openWayLink(){
        let url = NSURL(string: wayLinkValue)!
        UIApplication.shared.openURL(url as URL)
    }
    
    

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "SİZ")
    }
}

