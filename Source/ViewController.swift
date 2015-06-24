//
//  ViewController.swift
//  ProjectName
//
//  Created by Dominik Vesely on 04/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveCocoa



class ViewController : UIViewController {
    
    var label = UILabel()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .whiteColor()
        
        let button = UIButton()
        button.addEventHandler({ [weak self] (sender) in
            // push navigation
            
        }, forControlEvents: UIControlEvents.TouchUpInside)
        
        let img = UIImageView()
        
        
        

        let borrowButton = Theme.pinkButton()
        borrowButton!.frame = CGRectMake(10, 450, 300, 42)
        borrowButton!.setTitle("Borrow", forState: .Normal)
        self.view.addSubview(borrowButton!)
        
        let codeTextField = UITextField()
        codeTextField.frame = CGRectMake(10, 400, 300, 42)
        codeTextField.placeholder = "Enter 6-digit code"
        codeTextField.textAlignment = .Center
        codeTextField.backgroundColor = .rekolaGreyColor()
        self.view.addSubview(codeTextField)
        
        let infoLabel = UILabel()
        infoLabel.frame = CGRectMake(10, 200, 300, 90)
        infoLabel.text = "Enter the bike 6-digit code to receive the lock passcode and start using your bike."
        infoLabel.numberOfLines = 3
        infoLabel.textAlignment = .Center
        self.view.addSubview(infoLabel)
        
        let infoSubtitleLabel = UILabel()
        infoSubtitleLabel.frame = CGRectMake(30, 290, 280, 40)
        infoSubtitleLabel.text = "Code can be found on the rear fender or on a rear stick."
        infoSubtitleLabel.numberOfLines = 2
        infoSubtitleLabel.textAlignment = .Center
        infoSubtitleLabel.textColor = .grayColor()
        infoSubtitleLabel.font = UIFont.systemFontOfSize(13.0)
        self.view.addSubview(infoSubtitleLabel)
    }
    
    func keyboardWasShown(aNotification: NSNotification) {
        var info: NSDictionary = aNotification.userInfo!
        var kbSize = info.valueForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue().size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize!.height, 0.0)
        
        
    }
    
    
}

