//
//  NewsVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 28/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
class NewsVC : UIViewController,UITableViewDelegate,UITableViewDataSource,ActivityIndicatorPresenter {
    var result = [MainPagePojo]()
    var userid : String = ""
    var autoid : String = ""
    var firebaseToken : String = ""
    var sendImageUrl : String = ""
    var sendNewsTitle : String = ""
    var sendNewsSummary : String = ""
    
     var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var lbl_noActivities: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let defaults:UserDefaults = UserDefaults.standard
        userid = defaults.string(forKey: "userid")!
        autoid = defaults.string(forKey: "autoid")!
        firebaseToken = defaults.string(forKey: "firebasetoken")!
        
        showActivityIndicator()
        getNews()
        
        if let image = UIImage(named: "üst bölüm.png") {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(result.count != 0){
            return result.count
        }
        else {
            lbl_noActivities.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        let aaa = result [indexPath.row]
        cell.setArray(mdataset : aaa)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendImageUrl = result[indexPath.row].imageUrl
        sendNewsTitle = result[indexPath.row].title
        sendNewsSummary = result[indexPath.row].summary
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "NewsDetail") as! NewsDetailVC
        myVC.imageURL = sendImageUrl
        myVC.ntitle = sendNewsTitle
        myVC.nSummary = sendNewsSummary
        self.navigationController!.pushViewController(myVC, animated: true)


        
    }
    
    func getNews(){
        var newsArray = [MainPagePojo]()
        let url = URL(string: "https://ekolife.ekoccs.com/api/News")!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let together = "\(autoid) \(firebaseToken)"
        config.httpAdditionalHeaders = ["Authorization" : together]
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
            print("response \(String(describing: data))")
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [AnyObject]
             
                DispatchQueue.main.async {
                    let totalArray : [AnyObject] = jsonResult!
                    for i in 0 ..< totalArray.count{
                        let news = totalArray[i] as! [String : AnyObject]
                        let newsId = news["InHaberId"] as! Int
                        let newsTitle = news["StHaberBasligi"] as! String
                        let newsSumm = news["StHaber"] as! String
                        let insertDate = news["DtInsertedDate"] as! String
                        let nullDetect =  news["StResimUrl"] as AnyObject
                        var imageURL : String = ""
                        if nullDetect is NSNull {
                            imageURL = ""
                        }
                        else{
                            imageURL = "http://mbs.vodasoft.com.tr/\(news["StResimUrl"] as! String)"
                        }
                        let mainpojo = MainPagePojo.init(imageUrl : imageURL, title: newsTitle, summary: newsSumm, newsId: newsId,newsDate: insertDate)
                        newsArray.append(mainpojo)
                        
                    }
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                        self.result = newsArray
                        self.newsTableView.reloadData()
                    }
                    
                
                }
            
                
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
}
