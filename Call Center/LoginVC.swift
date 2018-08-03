//
//  LoginVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 29/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
class LoginVC : UIViewController,ActivityIndicatorPresenter{
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    var userName: String = ""
    var password : String = ""
    var isMood : Bool = false
    var activityIndicator = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        let img = UIImage(named: "arka plan.png")
        view.layer.contents = img?.cgImage
        super.viewDidLoad()
    }
    @IBAction func sifremiUnuttum(_ sender: Any) {
        showActivityIndicator()
        sifremiUnuttum()
        
    }
    @IBAction func loginClicked(_ sender: Any) {
        showActivityIndicator()
        if String(userNameLabel.text!) != "" && String(passwordLabel.text!) != ""{
            
            userName = userNameLabel.text!
            password = passwordLabel.text!
            //postLogin()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if(isMood == false){
                
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                self.present(newViewController, animated: true, completion: nil)
            } else {
            
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "Mood") as! MoodVC
                self.present(newViewController, animated: true, completion: nil)
            }
        }
        else {
           
             /*let alert = UIAlertController(title: "Hata", message: "Kullanıcı Adı ve Şifrenizi Boş Bırakmayınız", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)*/
           
            postLogin()
   
          
        }
    
      
        
    }
    func postLogin(){
        let url = URL(string: "https://ekolife.ekoccs.com/token")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        //let postString = "grant_type=password&username=\(userName)&password=\(password)&cloudMessagingToken=1234"
        let postString = "grant_type=password&username=okoc&password=Ok124578!&cloudMessagingToken=1234"
        
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

    
    func sifremiUnuttum(){
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

