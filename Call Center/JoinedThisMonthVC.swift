//
//  JoinedThisMonthVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 29/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip
class JoinedThisMonthVC : UIViewController , IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource,ActivityIndicatorPresenter {
    
    @IBOutlet weak var joinThisMonthTableView: UITableView!
    var jThisMonthResult = [JoinusPojo]()
    var autoid : String = ""
    var firebaseToken : String = ""
    var userid  : String = ""
    var likedPersonId  : String = ""
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinThisMonthTableView.delegate = self
        joinThisMonthTableView.dataSource = self
        let defaults = UserDefaults.standard
        autoid = defaults.string(forKey: "autoid")!
        firebaseToken = defaults.string(forKey: "firebasetoken")!
        userid = defaults.string(forKey: "userid")!
        showActivityIndicator()
        getJoinUsThisMonth()
    }
    
    func tebrikClicked( sender: UIButton) {
        likedPersonId = jThisMonthResult[sender.tag].tebrikButton
        showActivityIndicator()
        tebrikLiked()
    }
    
    func instaClicked( sender: UIButton) {
        likedPersonId = jThisMonthResult[sender.tag].instalink
        let instagram = URL(string: likedPersonId)!
        
        if UIApplication.shared.canOpenURL(instagram) {
            UIApplication.shared.open(instagram, options: ["":""], completionHandler: nil)
        } else {
            print("Instagram not installed")
        }
    }
    
    func faceClicked( sender: UIButton) {
        likedPersonId = jThisMonthResult[sender.tag].facelink
         UIApplication.tryURL(["facebook://profile/\(likedPersonId)", "https://www.facebook.com/\(likedPersonId)"])
    }
    
    func tebrikLiked(){
        
        let url = URL(string: "https://ekolife.ekoccs.com/api/General/InsertLike?userId=\(userid)&likedPersonId=\(likedPersonId)&typeId=2")!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let together = "\(autoid) \(firebaseToken)"
        config.httpAdditionalHeaders = ["Authorization" : together]
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
            
            do {
                let JsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Int
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    if(JsonResult == 1){
                        let alert = UIAlertController(title: "Tebriğiniz İletildi", message: "Teşekürler", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Hata", message: "Bir Hata Oluştu !", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
    }
    
  
    
    func getJoinUsThisMonth(){
        var resultArray  = [JoinusPojo]()
        let url = URL(string: "https://ekolife.ekoccs.com/api/General/GetJoins?req=3")!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let together = "\(autoid) \(firebaseToken)"
        config.httpAdditionalHeaders = ["Authorization" : together]
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
            
            do {
                let JsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Array<Dictionary<String,Any>>
                DispatchQueue.main.async {
                    let totalarray : [Any]!  = JsonResult
                    for i in 0 ..< totalarray.count  {
                        let users = totalarray[i] as! [String : AnyObject]
                        let personalId : String = String(describing: users["InPersonelID"]!)
                        let personalName : String = String(describing: users["StFullName"]!)
                        let profImage : String = String(describing: users["StProfilePhoto"]!)
                        let phoneNumber : String = String(describing: users["StPhoneMobile"]!)
                        let personalEmail : String = String(describing: users["stFrmeMail"]!)
                        let firmName : String = String(describing: users["StProjectName"]!)
                        let instaLink : String = "" //String(describing: users["StInstagram"]!)
                        let faceLink : String = "" //String(describing: users["StFacebook"]!)
                        
                        let jThisMonthpojo = JoinusPojo.init(profImage: profImage, name: personalName, tebrikButton: personalId, phonenumber: phoneNumber, email: personalEmail, firmName: firmName, instalink : instaLink , facelink : faceLink )
                        resultArray.append(jThisMonthpojo)
                    }
                    
                }
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.jThisMonthResult = resultArray
                    
                    self.joinThisMonthTableView.reloadData()
                }
                
                
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jThisMonthResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : JoinThisMonthCell = joinThisMonthTableView.dequeueReusableCell(withIdentifier: "jointhismonthcell", for: indexPath) as! JoinThisMonthCell
        let cellCount  = indexPath.row
        if(cellCount%2 == 0){
            cell.backgroundView = UIImageView(image: UIImage(named: "konfeti turuncu.png"))
        } else
        {
            cell.backgroundView = UIImageView(image: UIImage(named: "konfeti yeşil.png"))
        }
        let goCell  =  jThisMonthResult[indexPath.row]
        cell.profilImage.image = #imageLiteral(resourceName: "Kişiler.png")
        cell.setArray(mdataset: goCell)
        
        cell.tebrikButton.tag = indexPath.row
        cell.tebrikButton.addTarget(self, action: #selector(tebrikClicked(sender:)), for: .touchUpInside )
        
        cell.instaButton.tag = indexPath.row
        cell.instaButton.addTarget(self, action: #selector(instaClicked(sender:)), for: .touchUpInside )
        
        cell.faceButton.tag = indexPath.row
        cell.faceButton.addTarget(self, action: #selector(faceClicked(sender:)), for: .touchUpInside )
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "BU AY")
}
}
