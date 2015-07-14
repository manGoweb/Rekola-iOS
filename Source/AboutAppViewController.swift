//
//  AboutAppViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 07/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

class AboutAppViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        self.view = view
        
        let button = UIButton()
        view.addSubview(button)
        button.snp_makeConstraints { make in
            make.bottom.equalTo(view).offset(-10)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(414)
        }
        self.button = button
    }
    
    weak var button: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
		
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("PROFILE_about", comment: "")
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        self.navigationController?.navigationBar.barTintColor = .rekolaGreenColor()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.button.setBackgroundImage(UIImage(imageIdentifier: .aboutApp), forState: .Normal)
        self.button.imageView?.contentMode = .ScaleAspectFit
        self.button.addTarget(self, action: "openUrl", forControlEvents: .TouchUpInside)
    }
    
    func openUrl() {
        if let url = NSURL(string: "http://ackee.cz") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
//        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
}
