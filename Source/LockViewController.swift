//
//  ViewController.swift
//  ProjectName
//
//  Created by Dominik Vesely on 04/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveCocoa



class LockViewController : UIViewController, UITextFieldDelegate {
    
    override func loadView() {
        
        let view  = UIView()
        self.view = view
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { make in
            make.left.top.right.equalTo(view)
			make.bottom.equalTo(keyboardLayoutGuide)
        }
        self.scrollView = scrollView
        
        let container = UIView()
        scrollView.addSubview(container)
        container.snp_makeConstraints { make in
            make.width.equalTo(scrollView).offset(-(L.contentInsets.left + L.contentInsets.right))
            make.edges.equalTo(scrollView).insets(L.contentInsets)
        }
        self.container = container
        
        let iv = UIImageView(image: UIImage(imageIdentifier: .logo))
		iv.contentMode = UIViewContentMode.ScaleAspectFit
        container.addSubview(iv)
        iv.snp_makeConstraints { make in
            make.top.left.right.equalTo(container)
            make.height.equalTo(150)
        }
        self.logoImageView = iv
        
        let titleLabel = Theme.titleLabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        container.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.left.right.equalTo(container)
            make.top.equalTo(iv.snp_bottom).offset(L.verticalSpacing)
        }
        self.titleLabel = titleLabel
        
        let subtitleLabel = Theme.subTitleLabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .Center
        container.addSubview(subtitleLabel)
        subtitleLabel.snp_makeConstraints { make in
            make.left.right.equalTo(container)
            make.top.equalTo(titleLabel.snp_bottom).offset(L.verticalSpacing)
        }
        self.subtitleLabel = subtitleLabel
        
        let textField = Theme.textField()
        textField.textAlignment = .Center
        container.addSubview(textField)
        textField.snp_makeConstraints { make in
            make.height.equalTo(55)
            make.left.right.equalTo(container)
            make.top.equalTo(subtitleLabel.snp_bottom).offset(L.verticalSpacing)
        }
        self.textField = textField
        
        let borrowButton = Theme.pinkButton()
        container.addSubview(borrowButton)
        borrowButton.snp_makeConstraints { make in
            make.top.equalTo(textField.snp_bottom).offset(L.verticalSpacing)
            make.left.right.bottom.equalTo(container)
            make.height.equalTo(60)
        }
        self.borrowButton = borrowButton
    }
    
    weak var scrollView: UIScrollView!
    weak var container: UIView!
    weak var logoImageView: UIImageView!
    weak var titleLabel: UILabel!
    weak var subtitleLabel: UILabel!
    weak var textField: UITextField!
    weak var borrowButton : UIButton!
    
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = .whiteColor()
		
        titleLabel.text = NSLocalizedString("LOCK_codeInfo", comment: "")
        subtitleLabel.text = NSLocalizedString("LOCK_codeDescription", comment: "")
        textField.delegate = self
        textField.placeholder = NSLocalizedString("LOCK_enterCode", comment: "")
        borrowButton!.setTitle(NSLocalizedString("LOCK_borrow", comment: ""), forState: .Normal)
        borrowButton.addTarget(self, action: "borrowBike", forControlEvents: .TouchUpInside)
    }
    
    func borrowBike() {
        let vc = BorrowBikeViewController()
        showViewController(vc, sender: nil)
//        presentViewController(vc, animated: true, completion: nil)
    }
}

