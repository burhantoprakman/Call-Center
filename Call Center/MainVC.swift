//
//  ViewController.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 29/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit


class MainVC: UIViewController , UITableViewDelegate , UITableViewDataSource,ActivityIndicatorPresenter   {
    
    @IBOutlet weak var MainPageTableView: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var joinusImage: UIImageView!
    @IBOutlet weak var birthdayImage: UIImageView!
    
    @IBOutlet weak var birthdayCount: UIButton!
    @IBOutlet weak var joinUsCount: UIButton!
    @IBOutlet weak var lblNoNews: UILabel!
    
    var news  = [MainPagePojo]()
    var result = [MainPagePojo]()
    
    var birthCount : Int = 0
    var joinCount : Int = 0
    var joinLikes : Int = -1
    var birthdayLikes : Int = -1
    
    var userid : String = ""
    var autoid : String = ""
    var firebaseToken : String = ""
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       birthdayCount.layer.cornerRadius = birthdayCount.frame.width/2
        joinUsCount.layer.cornerRadius = joinUsCount.frame.width/2
        
        if let image = UIImage(named: "üst bölüm.png") {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
        MainPageTableView.delegate = self
        MainPageTableView.dataSource = self
         let defaults:UserDefaults = UserDefaults.standard
        userid = defaults.string(forKey: "userid")!
        autoid = defaults.string(forKey: "autoid")!
        firebaseToken = defaults.string(forKey: "firebasetoken")!
        showActivityIndicator()
        getMainPageInformation()
        
     
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
 
     
       
     
            //User Interaction Enabled
            activityImage.isUserInteractionEnabled = true
            newsImage.isUserInteractionEnabled = true
            mealImage.isUserInteractionEnabled = true
            serviceImage.isUserInteractionEnabled = true
            let imageTap = UITapGestureRecognizer(target: self, action:#selector(MainVC.offerClick))
            let imageTap1 = UITapGestureRecognizer(target: self, action:#selector(MainVC.joinClick))
            let imageTap2 = UITapGestureRecognizer(target: self, action:#selector(MainVC.birthdayClick))

        
        
            let tap = UITapGestureRecognizer(target: self, action:#selector(MainVC.activityClick))
            let tap1 = UITapGestureRecognizer(target: self, action:#selector(MainVC.newsClick))
            let tap2 = UITapGestureRecognizer(target: self, action:#selector(MainVC.mealClick))
            let tap3 = UITapGestureRecognizer(target: self, action:#selector(MainVC.transportClick))
            //Add Recognizer
            activityImage.addGestureRecognizer(tap)
            newsImage.addGestureRecognizer(tap1)
            mealImage.addGestureRecognizer(tap2)
            serviceImage.addGestureRecognizer(tap3)
            offerImage.addGestureRecognizer(imageTap)
            joinusImage.addGestureRecognizer(imageTap1)
            birthdayImage.addGestureRecognizer(imageTap2)
        
 
        
    }
    func activityClick(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.view.window?.rootViewController = sw
         let  destinationController = self.storyboard?.instantiateViewController(withIdentifier: "activities") as! ActivitiesVC
        let navigationController = UINavigationController(rootViewController: destinationController)
        sw.pushFrontViewController(navigationController, animated: true)
    }
    func newsClick(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.view.window?.rootViewController = sw
       let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "News") as! NewsVC
        let navigationController = UINavigationController(rootViewController: destinationController)
        sw.pushFrontViewController(navigationController, animated: true)
        
    }
    func mealClick(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.view.window?.rootViewController = sw
         let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "lunchlist") as! LunchListVC
        let navigationController = UINavigationController(rootViewController: destinationController)
        sw.pushFrontViewController(navigationController, animated: true)
        
    }
    func transportClick(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.view.window?.rootViewController = sw
      let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "transport") as! TransportationVC
        let navigationController = UINavigationController(rootViewController: destinationController)
        sw.pushFrontViewController(navigationController, animated: true)
        
    }
    func offerClick(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "oneriSikayet") as! IhaveIdeaVC
        let navigationController = UINavigationController(rootViewController: destinationController)
        sw.pushFrontViewController(navigationController, animated: true)
        
    }
    func joinClick(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "JoinedUs") as! JoinedUsVC
        let navigationController = UINavigationController(rootViewController: destinationController)
        sw.pushFrontViewController(navigationController, animated: true)
        
    }
    func birthdayClick(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "Birthday") as! BirthdayVC
        let navigationController = UINavigationController(rootViewController: destinationController)
        sw.pushFrontViewController(navigationController, animated: true)
        
    }
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(news.count != 0){
              lblNoNews.isHidden = true
            return news.count
          
        }
        else {
            lblNoNews.isHidden = false
            MainPageTableView.isHidden = true
            return 3
        }
      
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MainPageTableViewCell = self.MainPageTableView.dequeueReusableCell(withIdentifier: "mainpagecell") as! MainPageTableViewCell
        //let aaa = news [indexPath.row]
        //cell.setArray(mdataset : aaa)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (MainPageTableView.frame.size.height) / 3
        return height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsId = news[indexPath.row].newsId
        getNewsDetail(id: newsId!)
    }
    func getMainPageInformation(){
        var threeNewsArray = [MainPagePojo]()
        let url = URL(string: "https://ekolife.ekoccs.com/api/General/GetHomePage?userId=\(userid)")!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let together = "\(autoid) \(firebaseToken)"
        config.httpAdditionalHeaders = ["Authorization" : together]
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
            print("response \(String(describing: data))")
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    let defaults:UserDefaults = UserDefaults.standard
                    let userImageString = jsonResult["userImage"] as! String
                    self.birthCount = jsonResult["birthdays"] as! Int
                    self.joinCount = jsonResult["joiners"] as! Int
                    self.joinLikes = jsonResult["joinlikes"] as! Int
                    self.birthdayLikes = jsonResult["birthdaylikes"] as! Int
                    defaults.set(userImageString, forKey: "userimage")
                    defaults.set(self.joinLikes, forKey: "joinlikes")
                    defaults.set(self.birthdayLikes, forKey: "birthdaylikes")
                    
                    let totalArray : [Any]! = jsonResult["lastnews"] as! [Any]
                    for i in 0 ..< totalArray.count{
                        let news = totalArray[i] as! [String : AnyObject]
                        let newsId = news["InHaberId"] as! Int
                        let newsTitle = news["StHaberBasligi"] as! String
                        let newsSumm = news["StHaberSumm"] as! String
                        let insertDate = news["DtInsertedDate"] as! String
                        let nullDetect =  news["StResimUrl"] as AnyObject
                        var imageURL : String = ""
                        if nullDetect is NSNull {
                            imageURL = ""
                        }
                        else{
                            imageURL = news["StResimUrl"] as! String
                        }
                        
                        
                        let mainpojo = MainPagePojo.init(imageUrl : imageURL, title: newsTitle, summary: newsSumm, newsId: newsId,newsDate: insertDate)
                        threeNewsArray.append(mainpojo)
                    
                }
                }
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.birthdayCount.setTitle("\(self.birthCount)", for: .normal)
                    self.joinUsCount.setTitle("\(self.joinCount)", for: .normal)
                    self.news = threeNewsArray
                    self.MainPageTableView.reloadData()
                }
            }
             catch let error as NSError {
                print(error.localizedDescription)
            }
            
          
            
        }
        task.resume()
    }

    func getNewsDetail(id : Int){
        
        var newsArray = [MainPagePojo]()
        let url = URL(string: "https://ekolife.ekoccs.com/api/News?id=\(id)")!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let together = "\(autoid) \(firebaseToken)"
        config.httpAdditionalHeaders = ["Authorization" : together]
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
            print("response \(String(describing: data))")
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                DispatchQueue.main.async {
                
            
                        let newsId = jsonResult["InHaberId"] as! Int
                        let newsTitle = jsonResult["StHaberBasligi"] as! String
                        let newsSumm = jsonResult["StHaber"] as! String
                        let insertDate = jsonResult["DtInsertedDate"] as! String
                        let nullDetect =  jsonResult["StResimUrl"] as AnyObject
                        var imageURL : String = ""
                        if nullDetect is NSNull {
                            imageURL = ""
                        }
                        else{
                            imageURL = jsonResult["StResimUrl"] as! String
                        }
                        let mainpojo = MainPagePojo.init(imageUrl : imageURL, title: newsTitle, summary: newsSumm, newsId: newsId,newsDate: insertDate)
                        newsArray.append(mainpojo)
                   
                    DispatchQueue.main.async {
                        self.result = newsArray
                    }
                    
                    
                }
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "NewsDetail") as! NewsDetailVC
                myVC.imageURL = newsArray[0].imageUrl
                myVC.ntitle = newsArray[0].title
                myVC.nSummary = newsArray[0].summary
                self.navigationController!.pushViewController(myVC, animated: true)
                
                
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
}

