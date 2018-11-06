//
//  SignUpVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 12/10/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var passwordTV: UITextField!
    @IBOutlet weak var usernameTV: UITextField!
    
    override func viewDidLoad() {
        let img = UIImage(named: "arka plan.png")
        view.layer.contents = img?.cgImage
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        let alert = UIAlertController(title: "Uyarı", message: "EkoLife çalışanı iseniz lütfen kayıt olma işlemi yapmayınız.Sistem yöneticinizden giriş bilgilerini alabilirsiniz.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signupClicked(_ sender: Any) {
        
        if(usernameTV.text != "" && passwordTV.text != ""){
            UserDefaults.standard.set(usernameTV.text, forKey: "username")
            UserDefaults.standard.set(passwordTV.text, forKey: "password")
            UserDefaults.standard.set(true, forKey: "kayitsizKullanici")
            self.dismiss(animated: true, completion: nil)
            
        }else {
            let alert = UIAlertController(title: "Hata", message: "Kullanıcı Adı ve Şifrenizi Boş Bırakmayınız", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
    }
    }
}
