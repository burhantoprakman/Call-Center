//
//  LunchListVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 02/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore


class LunchListVC : UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,ActivityIndicatorPresenter  {
  
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var lunchTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    var autoid : String = ""
    var firebaseToken : String = ""
    var mealMenus = [String]()
    
    var activityIndicator = UIActivityIndicatorView()
   
    
    let Months = ["Ocak","Şubat","Mart","Nisan","Mayıs","Haziran","Temmuz","Ağustos","Eylül","Ekim","Kasım","Aralık"]
    let daysOfMonth = ["Pzt","Sal","Çar","Per","Cum","Cmt","Paz"]
    var daysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonth = String()
    var numberOfEmptyBox = Int()
    var nextNumberOfEmptyBox = Int()
    var previousNumberOfEmptyBox = 0
    var direction = 0
    var positionIndex = 0
    var dayCounter = 0
    var selectedDay = 0
    var selectedDay1 = 0

    override func viewDidLoad() {
    super.viewDidLoad()
        let defaults = UserDefaults.standard
        autoid = defaults.string(forKey: "autoid")!
        firebaseToken = defaults.string(forKey: "firebasetoken")!
        lunchTableView.delegate = self
        lunchTableView.dataSource = self
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        if let image = UIImage(named: "üst bölüm.png") {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
        
        let date = Date()
        let monthString = date.getMonthName()
        currentMonth = Months[month]
        dateLabel.text = "\(currentMonth)"
        let w = (dateView.frame.width) / 7
        let h = (dateView.frame.height) / 2
        datesLabel.frame.size.width = w
        datesLabel.frame.size.height = h
        if( weekday == 0){
            weekday = 7
        }
        
        getStartDateDayPosition()
        showActivityIndicator()
        getMealMenus()
   
        }

    
    
    
    func getMealMenus(){
        let url = URL(string: "https://ekolife.ekoccs.com/api/General/GetMealMenus")!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let together = "\(autoid) \(firebaseToken)"
        config.httpAdditionalHeaders = ["Authorization" : together]
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error)  -> Void in
            
            do {
              
                let JsonResult = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:AnyObject]
                DispatchQueue.main.async {
                if(self.selectedDay != 0){
                    if (JsonResult["\(self.selectedDay)"]) == nil {
                        self.mealMenus = ["Bugün için Yemek Listesi Bulunamadı"]
                    }else {
                        self.mealMenus = JsonResult["\(self.selectedDay)"] as! [String]
                    }
                   
                }
                else {
                    if (JsonResult["\(day)"]) == nil {
                        self.mealMenus = ["Bugün için Yemek Listesi Bulunamadı"]
                    }else {
                        self.mealMenus = JsonResult["\(day)"] as! [String]
                    }
                }
                    
             
                }
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.lunchTableView.reloadData()
                }
                
                
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = lunchTableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.gray
        }
        else{
            cell.backgroundColor = UIColor.white
        }
        cell.textLabel?.text = mealMenus[indexPath.row]
        return cell
    }
    
    
    
    
    
func getStartDateDayPosition (){
        switch direction {
        case 0:
            numberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter > 0{
                
                numberOfEmptyBox = numberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if numberOfEmptyBox == 0{
                    numberOfEmptyBox = 7
                }
            }
            if numberOfEmptyBox == 7 {
                numberOfEmptyBox = 0
            }
            positionIndex = numberOfEmptyBox
        case 1...:
            nextNumberOfEmptyBox = (positionIndex + daysInMonth[month])%7
            positionIndex = nextNumberOfEmptyBox
        case -1:
            previousNumberOfEmptyBox = (7 - (daysInMonth[month] - positionIndex)%7)
            if previousNumberOfEmptyBox == 7{
                previousNumberOfEmptyBox = 0
            }
            positionIndex = previousNumberOfEmptyBox
        default:
            fatalError()
        }
        
    }
    
    
    
//-------------------------- CALENDAR COLECTIONVIEW IMPLEMENT ------------------------------------//
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch direction {
        case 0:
            return daysInMonth[month] + numberOfEmptyBox
        case 1:
            return daysInMonth[month] + nextNumberOfEmptyBox
        case -1:
            return daysInMonth[month] + previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        cell.backgroundColor = UIColor.clear
        cell.dateLabel.textColor = UIColor.black
        if(cell.isHidden){
            cell.isHidden = false
        }
        switch direction {
        case 0:
        cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1:
            cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - previousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        if Int(cell.dateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        
        
        switch indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34:
            if(Int(cell.dateLabel.text!)! > 0){
                cell.dateLabel.textColor = UIColor.gray
            }
        default:
            break
        }
        if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 - numberOfEmptyBox == day{
            cell.dateLabel.layer.cornerRadius = dateLabel.frame.width/2
            cell.dateLabel.textColor = UIColor.blue
        }
        else{
            cell.dateLabel.textColor = UIColor.black
        }
        if(selectedDay1 == indexPath.row){
            cell.backgroundColor = UIColor(red: 0.5804, green: 0.8667, blue: 0.8667, alpha: 1.0)        }
        else {
            cell.backgroundColor = UIColor.white
        }
    
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.Calendar.frame.size.width) / 7
        let height = width * 0.5 //ratio
        return CGSize(width: width, height: height);
    }
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let value = indexPath.row
        selectedDay = value-5
        selectedDay1 = value
        self.Calendar.reloadData()
        getMealMenus()
    }
}

