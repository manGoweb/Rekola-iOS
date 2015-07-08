//
//  ReturnBikeViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 08/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

class ReturnBikeViewController: UIViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .rekolaGreenColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = .rekolaGreenColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .whiteColor()

    }
}
