//
//  AllTransportVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 07/02/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class AllTransportVC: UIViewController, IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource {
  
    
    @IBOutlet weak var allTranportTableView: UITableView!
    
    var tYourResult = [TransportHeaderPojo]()
   
    var autoid : String = ""
    var firebaseToken : String = ""
    var userid : String = ""
      var wayLinkValue : String = ""
    var headerTag : Int = 0
    var rowTag : Int = 0
    var rowValue : Int = 0
    var phoneNumber : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allTranportTableView.delegate = self
        allTranportTableView.dataSource = self
        if ( UserDefaults.standard.bool(forKey: "kayitsizKullanici") == true ){
            //
        }else  {
            let defaults = UserDefaults.standard
            autoid = defaults.string(forKey: "autoid")!
            firebaseToken = defaults.string(forKey: "firebasetoken")!
            userid = defaults.string(forKey: "userid")!
            
            
            allTranportTableView.rowHeight = UITableViewAutomaticDimension
            getAllTransport()
        }
        
  
    }
    func getAllTransport(){
        var resultArray  = [TransportHeaderPojo]()
        let url = URL(string: "https://ekolife.ekoccs.com/api/General/GetServisListesi")!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let together = "\(autoid) \(firebaseToken)"
        config.httpAdditionalHeaders = ["Authorization" : together]
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
            
            do {
                let JsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Array<Dictionary<String,Any>>
                DispatchQueue.main.async {
                    
                    let totalarray : NSArray = JsonResult as NSArray
                    
                    for i in 0 ..< totalarray.count  {
                        let users = totalarray[i] as! [String : AnyObject]
                        let vardiya : String = String(describing: users["servis_saati"]!)
                        let serviceArray = users["servisler"] as! [Any]
                        var transportArray : [TransportPojo] = []
                        for j in 0 ..< serviceArray.count{
                            let services = serviceArray[j] as! [String : AnyObject]
                            let service : String = String(describing: services["StServis"]!)
                            let driverName : String = String(describing: services["StSurucuAdi"]!)
                            let driverPhone : String = String(describing: services["StSurucuGSM"]!)
                            let servicePlate : String = String(describing: services["StServisPlaka"]!)
                            let wayLink : String = String(describing: services["StGuzergahLink"]!)
                            let transportpojo = TransportPojo.init(serviceName: service, driverName: driverName, driverPhone: driverPhone, carPlate: servicePlate, wayLink: wayLink)
                            transportArray.append(transportpojo)
                        }
                        let tYourPojo = TransportHeaderPojo.init(headerName: vardiya, items: transportArray, collapsed: true)
                        resultArray.append(tYourPojo)
                    }
                
                    
                }
                DispatchQueue.main.async {
                    self.tYourResult = resultArray
                    
                    self.allTranportTableView.reloadData()
                }
                
                
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return tYourResult.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tYourResult[section].collapsed ? 0 : tYourResult[section].items.count
    }
    
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AllTransportCell = tableView.dequeueReusableCell(withIdentifier: "alltransportcell") as? AllTransportCell ??
            AllTransportCell(style: .default, reuseIdentifier: "alltransportcell")
        let item : TransportPojo = tYourResult[indexPath.section].items[indexPath.row]
        
      
        
        
        cell.setArray(mdataset: item)
        headerTag = indexPath.section
        rowTag = indexPath.row
        //cell.wayLink.tag = rowTag
    
        cell.wayLink.titleLabel?.text = tYourResult[indexPath.section].items[indexPath.row].wayLink
        cell.wayLink.addTarget(self, action: #selector(wayLinkButton(sender:)), for: .touchUpInside )
        
        
        return cell
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = tYourResult[section].headerName
    
        header.setCollapsed(tYourResult[section].collapsed)
        
        header.section = section
        header.delegate = self as? CollapsibleTableViewHeaderDelegate
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func wayLinkButton(sender: UIButton){
        if(wayLinkValue != "<null>"  || wayLinkValue != "" || wayLinkValue != nil  ){
            wayLinkValue =  (sender.titleLabel?.text)!
            openWayLink()
        }
        else{
            
        }
    }
    func openWayLink(){
        let url = NSURL(string: wayLinkValue)!
        UIApplication.shared.openURL(url as URL)
    }
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "SERVİSLER")
    }
}





