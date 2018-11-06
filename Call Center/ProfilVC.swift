//
//  ProfilVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 29/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ProfilVC : UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ActivityIndicatorPresenter {
    var autoid : String = ""
    var firebaseToken : String = ""
    var userid : String = ""
    var selectedPhoto:UIImage? = nil
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var profilImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var firmLabel: UILabel!
    @IBOutlet weak var faceTV: UITextField!
    @IBOutlet weak var instaTV: UITextField!
    @IBOutlet weak var linkedinTV: UITextField!
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
        
        if ( UserDefaults.standard.bool(forKey: "kayitsizKullanici") == true ){
           
        } else {
            let defaults = UserDefaults.standard
            autoid = defaults.string(forKey: "autoid")!
            firebaseToken = defaults.string(forKey: "firebasetoken")!
            userid = defaults.string(forKey: "userid")!
            
            showActivityIndicator()
            getUserProfil()
            
            
        }
        
      
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        if let image = UIImage(named: "üst bölüm.png") {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProfilVC.choosePhoto))
        profilImage.addGestureRecognizer(recognizer)
        
       
    }
    
    func choosePhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedPhoto = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        profilImage.image = selectedPhoto
        self.dismiss(animated: true, completion: nil)
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
                        self.faceTV.text = jsonResult["StFacebook"] as! String
                        self.instaTV.text = jsonResult["StInstagram"] as! String
                        self.linkedinTV.text = jsonResult["StLinkedin"] as! String
                  
                        
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
        let imageData = selectedPhoto?.jpeg(.low)
        let imageString = imageData != nil ? imageData?.base64EncodedString(options: []) : ""
        let together = "\(autoid) \(firebaseToken)"
      
        
        let params : [String: AnyObject] = [
            "InUserID": userid as AnyObject,
            "StFBUserName": self.faceTV.text as AnyObject,
            "StInsUserName" : self.instaTV.text as AnyObject,
            "StLnkdnUserName" : self.linkedinTV.text as AnyObject,
            "StProfileImage" : imageString! as AnyObject
        ]
        let parametersHeader = [
            "Content-Type" : "application/json",
            "Authorization": "\(together)"
        ]
        
        Alamofire.request(url, method: .post, parameters: params ,encoding: JSONEncoding.default, headers: parametersHeader).validate(statusCode: 200..<600)
            .responseJSON { response in
                switch response.result {
                case .success:
                    
                    self.hideActivityIndicator()
                    if (response.result.value != nil){
                        var dict = response.result.value as! NSDictionary
                        
                        if( dict["response"] as! Bool == false){
                            let alert = UIAlertController(title: "Hata", message: "Bir Hata Oluştu !", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        } else {
                            let alert = UIAlertController(title: "Başarılı", message: "İsteğiniz Gönderilmiştir", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else  {
                        let alert = UIAlertController(title: "Hata", message: "Bir hata oluştu lütfen sistem yöneticinize başvurunuz", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.getUserProfil()
                    }
                    
                case .failure(let error):
                    print(error)
                    //completion(dic,0)
                }

    }
    
    
    
    }
    
    
    
    
    
}
