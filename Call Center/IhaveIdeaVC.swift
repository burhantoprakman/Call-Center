//
//  IhaveIdeaVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 31/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class IhaveIdeaVC : UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ActivityIndicatorPresenter  {
  
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var galleryButtonClicked: UIImageView!
    var selectedPhoto:UIImage? = nil
    var autoid : String = ""
    var userid : String = ""
    var firebaseToken : String = ""
    var activityIndicator = UIActivityIndicatorView()
   
    @IBOutlet weak var bodyLabel: UITextField!
    @IBOutlet weak var titleLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ( UserDefaults.standard.bool(forKey: "kayitsizKullanici") == true ){
           
        } else {
            
            let defaults = UserDefaults.standard
            autoid = defaults.string(forKey: "autoid")!
            firebaseToken = defaults.string(forKey: "firebasetoken")!
            userid = defaults.string(forKey: "userid")!
        }
        
     
        let img = UIImage(named: "moodarkaplan.png")
        view.layer.contents = img?.cgImage
        self.hideKeyboardWhenTappedAround()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        if let image = UIImage(named: "üst bölüm.png") {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
        galleryButtonClicked.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(IhaveIdeaVC.choosePhoto))
        galleryButtonClicked.addGestureRecognizer(recognizer)
    
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
        self.dismiss(animated: true, completion: nil)
    }
    func postDatas(){
        showActivityIndicator()
        let imageData = selectedPhoto?.jpeg(.low)
        let imageString = imageData != nil ? imageData?.base64EncodedString(options: []) : ""
        let titleText = titleLabel.text!
        let bodyText = bodyLabel.text!
        let url = URL(string: "https://ekolife.ekoccs.com/api/General/InsertFikirSikayet")!
        let config = URLSessionConfiguration.default
        let together = "\(autoid) \(firebaseToken)"
//        config.httpAdditionalHeaders = ["Authorization" : together]
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        let postString = "InUserId=\(userid))&StKonu=\(titleText)&StNot=\(bodyText)&StImage=\(imageString)"
//        
//        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
//        request.httpBody = postString.data(using: .utf8)
        
        let params : [String: AnyObject] = [
            "InUserId": userid as AnyObject,
            "StKonu": titleText as AnyObject,
            "StNot" : bodyText as AnyObject,
            "StImage" : imageString! as AnyObject
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
                    }

                case .failure(let error):
                    print(error)
                    //completion(dic,0)
                }
        }
        
        
        
        
//
//        let task = session.dataTask(with: request ){ data, response, error in
//
//            if error != nil{
//                print("Get Request Error")
//            }
//            else{
//
//                if data != nil {
//
//                    do {
//                        let JsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
//                        DispatchQueue.main.async {
//                            self.hideActivityIndicator()
//                            let bool : Bool = JsonResult["response"] as! Bool
//                            if(!bool){
//                                let alert = UIAlertController(title: "Hata", message: "Bir Hata Oluştu !", preferredStyle: UIAlertControllerStyle.alert)
//                                alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
//
//                            } else {
//                                let alert = UIAlertController(title: "Başarılı", message: "İsteğiniz Gönderilmiştir", preferredStyle: UIAlertControllerStyle.alert)
//                                alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
//                            }
//
//
//
//                        }
//
//                    } // do bitişi
//                    catch {
//                        let alert = UIAlertController(title: "Hata", message: "Bir hata oluştu lütfen sistem yöneticinize başvurunuz", preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                        print("CATCH OLDU")
//                    }
//                }
//
//            }
//
//        }
//        task.resume()
}
    
  
    
    
    @IBAction func sendClicked(_ sender: Any) {
        postDatas()
    }
    
}   
