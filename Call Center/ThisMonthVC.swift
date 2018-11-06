//
//  ThisMonth.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 31/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class ThisMonthVC : UIViewController , IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource,ActivityIndicatorPresenter {
    
    @IBOutlet weak var bThisMonthTableView: UITableView!
    var bThisMonthResult = [BirthdayPojo]()
    var autoid : String = ""
    var firebaseToken : String = ""
    var likedPersonId  : String = ""
    var userid  : String = ""
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bThisMonthTableView.delegate = self
        bThisMonthTableView.dataSource = self
        
        if ( UserDefaults.standard.bool(forKey: "kayitsizKullanici") == true ){
            
        } else {
            let defaults = UserDefaults.standard
            autoid = defaults.string(forKey: "autoid")!
            firebaseToken = defaults.string(forKey: "firebasetoken")!
            userid = defaults.string(forKey: "userid")!
            
            showActivityIndicator()
            getThisWeekBirthday()
            
        }
        
       
}
    
    func tebrikClicked( sender: UIButton) {
        likedPersonId = bThisMonthResult[sender.tag].tebrikButton
        showActivityIndicator()
        tebrikLiked()
    }
    
    func instaClicked( sender: UIButton) {
        likedPersonId = bThisMonthResult[sender.tag].instaString
        let instagram = URL(string: likedPersonId)!
        
        if UIApplication.shared.canOpenURL(instagram) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(instagram, options: ["":""], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(instagram)
            }
        } else {
            print("Instagram not installed")
        }
    }
    
    func faceClicked( sender: UIButton) {
        likedPersonId = bThisMonthResult[sender.tag].faceString
       UIApplication.tryURL(["facebook://profile/\(likedPersonId)", "https://www.facebook.com/\(likedPersonId)"])
    }
    
    func tebrikLiked(){
        
        let url = URL(string: "https://ekolife.ekoccs.com/api/General/InsertLike?userId=\(userid)&likedPersonId=\(likedPersonId)&typeId=1")!
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
                        let alert = UIAlertController(title: "Başarılı", message: "Teşekürler", preferredStyle: UIAlertControllerStyle.alert)
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
    
    
    
    func getThisWeekBirthday(){
        var resultArray  = [BirthdayPojo]()
        let url = URL(string: "https://ekolife.ekoccs.com/api/General/GetBirthDays?req=3")!
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
                        let horoscope : String = String(describing: users["Horoscope"]!)
                        let personelInsta : String = String(describing: users["StInstagram"]!)
                        let personalFace : String = String(describing: users["StFacebook"]!)
                        let profImage : String = String(describing: users["StProfilePhoto"]!)
                        let isBeforeLiked : Bool = (users["BoIsLiked"] as! Bool)
                        
                        let bThisMonthpojo = BirthdayPojo.init(profImage: profImage, name: personalName, tebrikButton: personalId, instaString: personelInsta, faceString: personalFace, horoscope: horoscope, isBeforeLiked: isBeforeLiked)
                        resultArray.append(bThisMonthpojo)
                    }
                    
                }
                DispatchQueue.main.async {
                    
                    self.hideActivityIndicator()
                    self.bThisMonthResult = resultArray
                    self.bThisMonthTableView.reloadData()
                }
                
                
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bThisMonthResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : BirthdayThisMonthCell = bThisMonthTableView.dequeueReusableCell(withIdentifier: "birthdaythismonthcell", for: indexPath) as! BirthdayThisMonthCell
        let cellCount  = indexPath.row
        if(cellCount%2 == 0){
            cell.backgroundView = UIImageView(image: UIImage(named: "konfeti turuncu.png"))
        } else
        {
            cell.backgroundView = UIImageView(image: UIImage(named: "konfeti yeşil.png"))
        }
        let goCell  =  bThisMonthResult[indexPath.row]
        cell.profilImage.image = #imageLiteral(resourceName: "Kişiler.png")
        cell.setArray(mdataset: goCell)
        
        cell.tebrikButton.tag = indexPath.row
        cell.tebrikButton.addTarget(self, action: #selector(tebrikClicked(sender:)), for: .touchUpInside )
        
        cell.faceButton.tag = indexPath.row
        cell.faceButton.addTarget(self, action: #selector(faceClicked(sender:)), for: .touchUpInside )
        
        cell.instaButton.tag = indexPath.row
        cell.instaButton.addTarget(self, action: #selector(instaClicked(sender:)), for: .touchUpInside )
        
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

    
    
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "HAFTAYA")
    }
}
