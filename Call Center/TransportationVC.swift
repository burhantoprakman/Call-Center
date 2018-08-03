//
//  TransportationVC.swift
//  Call Center
//
//  Created by Burhan TOPRAKMAN on 07/02/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TransportationVC: ButtonBarPagerTabStripViewController {
     let purpleInspireColor = UIColor(red: 0.5098, green: 0, blue: 0.8275, alpha: 1.0)

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
      
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.selectedBarHeight = 5.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            oldCell?.contentView.backgroundColor = self?.purpleInspireColor
            newCell?.contentView.backgroundColor = .white
            newCell?.label.textColor = self?.purpleInspireColor
           
        }
        super.viewDidLoad()
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
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "your")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "all")
        return [child_1, child_2]
    }


}
