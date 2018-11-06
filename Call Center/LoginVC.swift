//
//  LoginVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 29/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class LoginVC : UIViewController,ActivityIndicatorPresenter{
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    var userName: String = ""
    var password : String = ""
    var isMood : Bool = false
    var activityIndicator = UIActivityIndicatorView()
    var opened : Bool = false
    
    override func viewDidLoad() {
        let img = UIImage(named: "arka plan.png")
        view.layer.contents = img?.cgImage
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    @IBAction func sifremiUnuttum(_ sender: Any) {
        showActivityIndicator()
        sifremiUnuttumm()
        
    }
    @IBAction func loginClicked(_ sender: Any) {
        showActivityIndicator()
        if String(userNameLabel.text!) != "" && String(passwordLabel.text!) != ""{
            
            if ( UserDefaults.standard.bool(forKey: "kayitsizKullanici") == true ){
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                self.present(newViewController, animated: true, completion: nil)
            } else {
                userName = userNameLabel.text!
                password = passwordLabel.text!
                postLogin()
            }
            
          
           
        }
        else {
           
             let alert = UIAlertController(title: "Hata", message: "Kullanıcı Adı ve Şifrenizi Boş Bırakmayınız", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func postLogin(){
        self.hideActivityIndicator()
         let url = URL(string: "https://ekolife.ekoccs.com/token")!
              let postString = "grant_type=password&username=\(userName)&password=\(password)&cloudMessagingToken=1234"
        let params : [String: AnyObject] = [
            "grant_type": "password" as AnyObject,
            "username": userName as AnyObject,
            "password" : password as AnyObject,
            "cloudMessagingToken" : "1234" as AnyObject
        ]
        let parametersHeader = [
            "Content-Type" : "application/x-www-form-urlencoded",
        ]
        
        Alamofire.request(url, method: .post, parameters: params ,encoding: URLEncoding.httpBody, headers: parametersHeader).validate(statusCode: 200..<600)
            .responseJSON { response in
                switch response.result {
                case .success:
                    var JsonResult = response.result.value as! NSDictionary
                    
                    if(JsonResult["error_description"] != nil){
                        let alert = UIAlertController(title: "Hata", message: "Kullanıcı yada Şifreniz Hatalı", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let userNameSurname = JsonResult["userFullName"] as! String
                        let userId = JsonResult["userid"] as! String
                        let department  = JsonResult["department"] as! String
                        let autoId  = JsonResult["token_type"] as! String
                        let firebaseToken = JsonResult["access_token"] as! String
                        
                        let defaults:UserDefaults = UserDefaults.standard
                        defaults.set(userId, forKey: "userid")
                        defaults.set(self.userName, forKey: "username")
                        defaults.set(self.password, forKey: "password")
                        defaults.set(userNameSurname, forKey: "usernamesurname")
                        defaults.set(department, forKey: "department")
                        defaults.set(autoId, forKey: "autoid")
                        defaults.set(firebaseToken, forKey: "firebasetoken")
                        defaults.synchronize()
                        self.opened = true
                        self.openMainPage()
                    }
                    
                case .failure(let error):
                    print(error)
                    //completion(dic,0)
                }
        }
    }
    func openMainPage(){
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if(opened == true){
            if(self.isMood == false){
                
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                self.present(newViewController, animated: true, completion: nil)
            } else {
                
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "Mood") as! MoodVC
                self.present(newViewController, animated: true, completion: nil)
            }
        }
       
    }

    
    func sifremiUnuttumm(){
        let url = URL(string: "https://ekolife.ekoccs.com/api/General/GetSystemParameter?value=FORGOTPWD")!
        let session = URLSession.shared
        let task = session.dataTask(with: url ){ data, response, error in
            
            if error != nil{
                print("Get Request Error")
            }
            else{
                
                if data != nil {
                    
                    do {
                        let JsonResult = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as AnyObject
                        DispatchQueue.main.async {
                            self.hideActivityIndicator()
                        let alert = UIAlertController(title: "Hata", message: "\(JsonResult)", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        }
                    } // do bitişi
                    catch {
                        print("CATCH OLDU")
                    }
                }
                
            }
            
        }
        task.resume()
        
    }
  
}
