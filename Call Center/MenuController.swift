//
//  MenuController.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 03/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit

class MenuController : UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet var menuTV: UITableView!
   
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var profilNameSurname: UILabel!
    var MinHeight : CGFloat = 30.0
    
    let menuItems = ["Ana Sayfa","Haberler","Etkinlikler","Yemek","Servis","Aramıza Katılanlar","Bugün Doğanlar","Öneri-Şikayet","Kişiler","Profilim","Çıkış"]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTV.delegate = self
        menuTV.dataSource = self
        menuTV.backgroundColor = UIColor.blue
        
        let defaults:UserDefaults = UserDefaults.standard
        let username = defaults.string(forKey: "usernamesurname")
        let imageurl = defaults.string(forKey: "userimage")!
        let jLikes = defaults.integer(forKey: "joinlikes")
        let bLikes = defaults.integer(forKey: "birthdaylikes")
        
        profilNameSurname.textColor = UIColor.white
        profilImageView.setImageFromURl(stringImageUrl: imageurl)
        profilImageView.layer.cornerRadius = profilImageView.frame.width/2
        if(jLikes != 0 ){
            profilNameSurname.text = "Aramıza Hoşgeldin \(String(describing: username))"
        } else {
            profilNameSurname.text = username
        }
        if (bLikes != 0){
            profilNameSurname.text = "Doğum Günün Kutlu Olsun \(String(describing: username))"
            
        } else {
            profilNameSurname.text = username
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let theight = menuTV.bounds.height
        let temp = theight/CGFloat(menuItems.count)
        return temp > MinHeight ? temp : MinHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SideMenuCell = self.menuTV.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! SideMenuCell
        cell.menuLabel.text = menuItems[indexPath.row]
        
        
       /* if(cell.menuLabel.text == "Profilim"){
            let defaults:UserDefaults = UserDefaults.standard
            let imageurl = defaults.string(forKey: "userimage")!
            let imgURL = imageurl
            self.profilImageView.setImageFromURl(stringImageUrl: imgURL)
            cell.menuImageView.image = profilImageView.image
        } else {
            let imagee = UIImage(named: menuItems[indexPath.row])
            cell.menuImageView.image = imagee
        }*/
        let imagee = UIImage(named: menuItems[indexPath.row])
        cell.menuImageView.image = imagee
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
     
        switch indexPath.row {
        case 0:
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") as! MainVC
            let navigationController = UINavigationController(rootViewController: destinationController)
            sw.pushFrontViewController(navigationController, animated: true)
            
        case 1:
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "News") as! NewsVC
            let navigationController = UINavigationController(rootViewController: destinationController)
            sw.pushFrontViewController(navigationController, animated: true)
            
        case 2:
            self.view.window?.rootViewController = sw
           let  destinationController = self.storyboard?.instantiateViewController(withIdentifier: "activities") as! ActivitiesVC
            let navigationController = UINavigationController(rootViewController: destinationController)
            sw.pushFrontViewController(navigationController, animated: true)
           
        case 3:
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "lunchlist") as! LunchListVC
            let navigationController = UINavigationController(rootViewController: destinationController)
            sw.pushFrontViewController(navigationController, animated: true)
           
        case 4:
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "transport") as! TransportationVC
            let navigationController = UINavigationController(rootViewController: destinationController)
            sw.pushFrontViewController(navigationController, animated: true)
           
        case 5:
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "JoinedUs") as! JoinedUsVC
            let navigationController = UINavigationController(rootViewController: destinationController)
            sw.pushFrontViewController(navigationController, animated: true)
          
        case 6:
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "Birthday") as! BirthdayVC
            let navigationController = UINavigationController(rootViewController: destinationController)
            sw.pushFrontViewController(navigationController, animated: true)
            
        case 7:
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "oneriSikayet") as! IhaveIdeaVC
            let navigationController = UINavigationController(rootViewController: destinationController)
            sw.pushFrontViewController(navigationController, animated: true)
           
        case 8:
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "Personal") as! PersonalVC
            let navigationController = UINavigationController(rootViewController: destinationController)
            sw.pushFrontViewController(navigationController, animated: true)
        case 9:
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "Profil") as! ProfilVC
            let navigationController = UINavigationController(rootViewController: destinationController)
            sw.pushFrontViewController(navigationController, animated: true)
        case 10:
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginVC
            sw.pushFrontViewController(destinationController, animated: true)
            
        default:
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") as! MainVC
            let navigationController = UINavigationController(rootViewController: destinationController)
            sw.pushFrontViewController(navigationController, animated: true)
        }
        
        
    }
    
    
}
