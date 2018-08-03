//
//  PersonalVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 26/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit


class PersonalVC : UIViewController, UITableViewDelegate , UITableViewDataSource,UISearchBarDelegate,ActivityIndicatorPresenter {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var peronalTableView: UITableView!
    private var personelResult = [PersonalPojo]()
    var currentPersonelResult = [PersonalPojo]()
    var autoid : String = ""
    var firebaseToken : String = ""
    var activityIndicator = UIActivityIndicatorView()

    
    
    var listSection = [String]()
    var listDic = [String:[String]]()
    var listIndexTitle  = ["A","B","C","Ç","D","E","F","G","H","I","İ","J","K","L","M","N","O","Ö","P","R","S","Ş","T","U","Ü","V","Y","Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        if let image = UIImage(named: "üst bölüm.png") {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
        peronalTableView.delegate = self
        peronalTableView.dataSource = self
    
        let defaults:UserDefaults = UserDefaults.standard
        autoid = defaults.string(forKey: "autoid")!
        firebaseToken = defaults.string(forKey: "firebasetoken")!
        showActivityIndicator()
        getPersonelData()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
      
      
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentPersonelResult.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PersonelCell  = peronalTableView.dequeueReusableCell(withIdentifier: "personelCell", for: indexPath) as! PersonelCell
        
            let goCell = currentPersonelResult[indexPath.row]
            cell.profilImage.image = #imageLiteral(resourceName: "Kişiler.png")
            cell.setArray(mdataset : goCell)
            
        
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return currentPersonelResult.count
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return listIndexTitle
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int{
      
        
        guard let index = listSection.index(of: title)
            else {
            return -1
        }
        return index
    }
    
    func getPersonelData(){
            var resultArray  = [PersonalPojo]()
            let url = URL(string: "https://ekolife.ekoccs.com/api/User")!
            let request = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            let together = "\(autoid) \(firebaseToken)"
            config.httpAdditionalHeaders = ["Authorization" : together]
            let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
            
            let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
                print("response \(String(describing: data))")
                
                do {
                    let JsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Array<Dictionary<String,Any>>
                    DispatchQueue.main.async {
                        let totalarray : [Any]!  = JsonResult
                        for i in 0 ..< totalarray.count  {
                            let users = totalarray[i] as! [String : AnyObject]
                            let personalId : String = String(describing: users["InPersonelID"]!)
                            let personalEmail  : String = String(describing: users["stFrmeMail"]!)
                            let personalName : String = String(describing: users["StFullName"]!)
                            let personalFirm : String = String(describing: users["StProjectName"]!)
                            let personelInsta : String = String(describing: users["StInstagram"]!)
                            let personalFace : String = String(describing: users["StFacebook"]!)
                            let personalImage : String = String(describing: users["StProfilePhoto"]!)
                            
                            let personalPojo = PersonalPojo.init(profilImage: personalImage, firmName: personalFirm, nameSurname: personalName, id: personalId, email: personalEmail, instaString: personelInsta, faceString: personalFace)
                            resultArray.append(personalPojo)
                            
                            
                      
                        }
                        for i in 0 ..< resultArray.count {
                            self.listSection.append(resultArray[i].nameSurname)
                        }
                    }
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                        self.personelResult = resultArray
                        self.currentPersonelResult = self.personelResult
                        self.peronalTableView.reloadData()
                    }
                       
                    
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
            task.resume()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentPersonelResult = personelResult.filter({ personal -> Bool in
                if searchText.isEmpty { return true }
                return personal.nameSurname.lowercased().contains(searchText.lowercased())
            
        })
        peronalTableView.reloadData()
    }
 
}
