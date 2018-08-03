//
//  MoodVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 29/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
class MoodVC : UIViewController,ActivityIndicatorPresenter {
    
    @IBOutlet weak var hayatZorButton: UIView!
    @IBOutlet weak var gevsekButton: UIView!
    @IBOutlet weak var oynatmayaButton: UIView!
    @IBOutlet weak var asabiButton: UIView!
    @IBOutlet weak var uykuluButton: UIView!
    @IBOutlet weak var neseliButton: UIView!
    
    var autoid : String = ""
    var firebaseToken : String = ""
    var userid : String = ""
    var together : String = ""
    var activityIndicator = UIActivityIndicatorView()
    
    
    var moodId : Int = -1
    
    override func viewDidLoad() {
        let img = UIImage(named: "moodarkaplan.png")
        view.layer.contents = img?.cgImage
        
        let defaults = UserDefaults.standard
        autoid = defaults.string(forKey: "autoid")!
        firebaseToken = defaults.string(forKey: "firebasetoken")!
        userid = defaults.string(forKey: "userid")!
        together = "\(autoid) \(firebaseToken)"
          let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.hayatZor(sender:)))
          self.hayatZorButton.addGestureRecognizer(gesture)
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gevsek(sender:)))
        self.gevsekButton.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.oynatmaya(sender:)))
        self.oynatmayaButton.addGestureRecognizer(gesture2)
        
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.asabi(sender:)))
        self.asabiButton.addGestureRecognizer(gesture3)
        
        let gesture4 = UITapGestureRecognizer(target: self, action:  #selector(self.uykulu(sender:)))
        self.uykuluButton.addGestureRecognizer(gesture4)
        
        let gesture5 = UITapGestureRecognizer(target: self, action:  #selector(self.neseli(sender:)))
        self.neseliButton.addGestureRecognizer(gesture5)
       
    }
    
  
    
    func hayatZor(sender : UITapGestureRecognizer) {
        moodId = 4
        postRequest(userid: userid, moodId: moodId, autoId: together)
        showActivityIndicator()
        
    }
    func gevsek(sender : UITapGestureRecognizer) {
        moodId = 5
         postRequest(userid: userid, moodId: moodId, autoId: together)
         showActivityIndicator()
    }
    func oynatmaya(sender : UITapGestureRecognizer) {
        moodId = 3
        postRequest(userid: userid, moodId: moodId, autoId: together)
         showActivityIndicator()
    }
    func asabi(sender : UITapGestureRecognizer) {
        moodId = 2
        postRequest(userid: userid, moodId: moodId, autoId: together)
         showActivityIndicator()
    }
    func uykulu(sender : UITapGestureRecognizer) {
        moodId = 1
        postRequest(userid: userid, moodId: moodId, autoId: together)
         showActivityIndicator()
    }
    func neseli(sender : UITapGestureRecognizer) {
        moodId = 0
        postRequest(userid: userid, moodId: moodId, autoId: together)
         showActivityIndicator()
    }
    
    
    func postRequest(userid : String,moodId : Int , autoId : String){
        
        let url = URL(string: "https://ekolife.ekoccs.com/token")!
        var request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization" : together]
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
         let postString = "InUserId=\(userid)&InMood=\("\(moodId)")"
        
        request.httpBody = postString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request ){ data, response, error in
            
            if error != nil{
                print("Get Request Error")
            }
            else{
                
                if data != nil {
                    
                    do {
                        let JsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        DispatchQueue.main.async {
                            self.hideActivityIndicator()
                            if (JsonResult["response"] as! Bool == true){
                                let alert = UIAlertController(title: "Başarılı", message: "Mood'unuz gönderildi", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }else {
                                let alert1 = UIAlertController(title: "Hata", message: "Bir hata oluştu lütfen daha sonra tekrar deneyiniz", preferredStyle: UIAlertControllerStyle.alert)
                                alert1.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert1, animated: true, completion: nil)
                                
                            }
                            
                        }
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        self.present(newViewController, animated: true, completion: nil)
                        
                    } // do bitişi
                    catch {
                        print("CATCH OLDU")
                    }
                }
                
            }
            
        }
        task.resume()
        
    }
    
    @IBAction func nedenSoruyoruzClicked(_ sender: Any) {
        
        let url = URL(string: "https://ekolife.ekoccs.com/api/General/GetSystemParameter?value=MOODHELP")!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization" : together]
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
            print("response \(String(describing: data))")
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    let alert2 = UIAlertController(title: "Neden Soruyoruz", message: "\(jsonResult)", preferredStyle: UIAlertControllerStyle.alert)
                    alert2.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert2, animated: true, completion: nil)
                    
                    
                    }
       
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
    }
        task.resume()
    
}
}
