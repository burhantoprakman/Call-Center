//
//  ProfilVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 29/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
class ProfilVC : UIViewController,ActivityIndicatorPresenter {
    var autoid : String = ""
    var firebaseToken : String = ""
    var userid : String = ""
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var profilImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var firmLabel: UILabel!
    @IBOutlet weak var faceLabel: UILabel!
    @IBOutlet weak var linkedLabel: UILabel!
    @IBOutlet weak var intaLabel: UILabel!
    @IBOutlet weak var profilUpdate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let purpleColor = UIColor(red: 0.5098, green: 0, blue: 0.8275, alpha: 1.0)
        self.profilImage.layer.cornerRadius = self.profilImage.frame.size.width / 2
        self.profilImage.clipsToBounds = true
        self.profilUpdate.layer.cornerRadius = self.profilUpdate.frame.size.width / 4
        self.profilUpdate.clipsToBounds = true
        profilUpdate.backgroundColor = purpleColor
        self.hideKeyboardWhenTappedAround()
        
        let defaults = UserDefaults.standard
        autoid = defaults.string(forKey: "autoid")!
        firebaseToken = defaults.string(forKey: "firebasetoken")!
        userid = defaults.string(forKey: "userid")!
        
        showActivityIndicator()
        getUserProfil()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        if let image = UIImage(named: "üst bölüm.png") {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
        
       
    }
    @IBAction func profilUpdateClicked(_ sender: Any) {
        showActivityIndicator()
        getUpdateProfil()
        
    }
    
    func getUserProfil(){
         let url = URL(string:"https://ekolife.ekoccs.com/api/User/GetUserProfile?userId=\(userid)")!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let together = "\(autoid) \(firebaseToken)"
        config.httpAdditionalHeaders = ["Authorization" : together]
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
            print("response \(String(describing: data))")
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                     DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
                    self.nameLabel.text = jsonResult["StFullName"] as? String
                    self.mailLabel.text = jsonResult["stFrmeMail"] as? String
                    self.firmLabel.text = jsonResult["StProjectName"] as? String
                    let imageurl = jsonResult["StUserImage"] as? String
                    let imgURL = imageurl
                    self.profilImage.setImageFromURl(stringImageUrl: imgURL!)
                    self.faceLabel.text = jsonResult["StFacebook"] as? String
                    self.intaLabel.text = jsonResult["StInstagram"] as? String
                    self.linkedLabel.text = jsonResult["StInstagram"] as? String
                
                        
                    }
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
        
    }
    
    func getUpdateProfil(){
        self.hideActivityIndicator()
        let url = URL(string: "https://ekolife.ekoccs.com/api/User/UpdateUser")!
        var request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "InUserID: \("2319"),StFBUserName:\("qwe"),StInsUserName:\("asd"),StLnkdnUserName:\("zxc"),StProfileImage:\("")"
        request.httpBody = postString.data(using: .utf8)
        let together = "\(autoid) \(firebaseToken)"
        config.httpAdditionalHeaders = ["Authorization" : together]
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
           // print("response \(String(describing: data))")
            do {
               
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                     DispatchQueue.main.async {
                    let defaults:UserDefaults = UserDefaults.standard
                    let userImageString = jsonResult["userImage"] as! String
                    defaults.set(userImageString, forKey: "userimage")
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
}
