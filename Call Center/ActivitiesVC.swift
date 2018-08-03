//
//  ActivitiesVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 05/02/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
class ActivitiesVC : UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,ActivityIndicatorPresenter {
 
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var activityCollectionView: UICollectionView!
    
    @IBOutlet weak var lbl_noActivity: UILabel!
    
    var autoid : String = ""
    var firebaseToken : String = ""
    var acitivityList = [ActivitiesPojo]()
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        let defaults = UserDefaults.standard
        autoid = defaults.string(forKey: "autoid")!
        firebaseToken = defaults.string(forKey: "firebasetoken")!
        showActivityIndicator()
        getActivitiesData()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        if let image = UIImage(named: "üst bölüm.png") {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
    }
    func getActivitiesData(){
        var resultArray  = [ActivitiesPojo]()
        let url = URL(string: "https://ekolife.ekoccs.com/api/Etkinlik")!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let together = "\(autoid) \(firebaseToken)"
        config.httpAdditionalHeaders = ["Authorization" : together]
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
            
            do {
                
                let JsonResult = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [AnyObject]
                DispatchQueue.main.async {
                    let jArray : [AnyObject] = JsonResult
                    var activityLocation : String
                    for i in 0 ..< jArray.count{
                   let activities = jArray[i] as! [String : AnyObject]
                   let activityTitle = activities["StEtkinlikBasligi"] as! String
                   let activityText = activities["StEtkinlikOzet"] as! String
                        if(activities["StLokasyon"] is NSNull){
                            activityLocation = ""
                        }
                        else{
                           activityLocation = activities["StLokasyon"] as! String
                        }
                        
                   let startDate = activities["DtEtkinlikBaslangicTarihi"] as! String
                   let finishDate = activities["DtEtkinlikBitisTarihi"] as! String
                    let activityPojo = ActivitiesPojo.init(activityTitle: activityTitle, activityDetail: activityText, place: activityLocation, date: startDate)
                    resultArray.append(activityPojo)
                    
                    }
                }
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.acitivityList = resultArray
                    self.activityCollectionView.reloadData()
                }
                
                
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(acitivityList.count != 0){
            return acitivityList.count
        }else{
            lbl_noActivity.isHidden = false
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = activityCollectionView.dequeueReusableCell(withReuseIdentifier: "activitycell", for: indexPath) as! ActivitiesCell
        let goCell  =  acitivityList[indexPath.row]
        cell.setArray(mdataset: goCell)
        
        return cell
    }
   
}
