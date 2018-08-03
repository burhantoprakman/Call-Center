//
//  NewsDetailVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 02/03/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit

class NewsDetailVC: UIViewController {

    @IBOutlet weak var returnNews: UIBarButtonItem!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    
    @IBOutlet weak var newsSummary: UITextView!
    var imageURL : String = ""
    var ntitle : String = ""
    var nSummary : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let image = UIImage(named: "üst bölüm.png") {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
        newsImage.setImageFromURl(stringImageUrl: imageURL)
        newsTitle.text = ntitle
        newsSummary.text = nSummary
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func returnNews(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "News") as! NewsVC
        let navigationController = UINavigationController(rootViewController: destinationController)
        sw.pushFrontViewController(navigationController, animated: true)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func shareClicked(_ sender: Any) {
        let title = newsTitle.text
        let text  = newsSummary.text
        let image = newsImage.image
      
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [image!, text ?? "",title ?? "" ], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo,UIActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
    }
    



}
