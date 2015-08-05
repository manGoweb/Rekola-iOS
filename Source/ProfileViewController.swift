//
//  ProfileViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 01/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import SnapKit
import ReactiveCocoa

class ProfileViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .whiteColor()
        self.view = view
        
        let nameLabel = UILabel()
        view.addSubview(nameLabel)
        nameLabel.font = UIFont.boldSystemFontOfSize(26)
        nameLabel.textAlignment = .Center
        nameLabel.snp_makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(100)
            }
        self.nameLabel = nameLabel
        
        let dateLabel = UILabel()
        view.addSubview(dateLabel)
        dateLabel.textColor = .rekolaPinkColor()
        dateLabel.textAlignment = .Center
        dateLabel.snp_makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(nameLabel.snp_bottom).offset(L.verticalSpacing)
        }
        self.dateLabel = dateLabel
        
        let logoutButton = TintingButton(titleAndImageTintedWith: .rekolaGreenColor(), activeTintColor: UIColor.whiteColor())
        view.addSubview(logoutButton)
        logoutButton.setImage(UIImage(imageIdentifier: .logoutButton), forState: .Normal)
        logoutButton.layer.borderColor = UIColor.rekolaGreenColor().CGColor
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.cornerRadius = 4
        logoutButton.snp_makeConstraints { make in
            make.width.equalTo(169)
            make.height.equalTo(44)
            make.top.equalTo(dateLabel.snp_bottom).offset(L.verticalSpacing)
//                    make.left.right.equalTo(view)
            make.centerX.equalTo(view.snp_centerX)
        }
        self.logoutButton = logoutButton
        
        let staticEmailLabel = UILabel()
        staticEmailLabel.text = NSLocalizedString("PROFILE_email", comment: "")
        staticEmailLabel.textColor = .staticGrayTextColor()
        staticEmailLabel.textAlignment = .Left
        view.addSubview(staticEmailLabel)
        staticEmailLabel.snp_makeConstraints { make in
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.top.equalTo(logoutButton.snp_bottom).offset(L.verticalSpacing)
        }
        
        let emailLabel = UILabel()
        view.addSubview(emailLabel)
        emailLabel.textAlignment = .Right
        emailLabel.snp_makeConstraints { make in
            make.left.greaterThanOrEqualTo(staticEmailLabel.snp_right).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing).priorityLow()
            make.top.equalTo(logoutButton.snp_bottom).offset(L.verticalSpacing)
        }
        self.emailLabel = emailLabel
        
        let line1 = Theme.lineView()
        view.addSubview(line1)
        line1.snp_makeConstraints { make in
            make.top.equalTo(emailLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
            make.height.equalTo(1)
//            make.width.equalTo(300)
        }
        
        let staticAddressLabel = UILabel()
        staticAddressLabel.text = NSLocalizedString("PROFILE_address", comment: "")
        staticAddressLabel.textColor = .staticGrayTextColor()
        staticAddressLabel.textAlignment = .Left
        view.addSubview(staticAddressLabel)
        staticAddressLabel.snp_makeConstraints { make in
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.top.equalTo(line1.snp_bottom).offset(L.verticalSpacing)
        }
        
        let addressLabel = UILabel()
        view.addSubview(addressLabel)
        addressLabel.textAlignment = .Left
        addressLabel.snp_makeConstraints { make in
            make.right.equalTo(view).offset(-L.horizontalSpacing).priorityLow()
            make.left.greaterThanOrEqualTo(staticAddressLabel.snp_right).offset(L.horizontalSpacing)
            make.top.equalTo(line1.snp_bottom).offset(L.verticalSpacing)
        }
        self.addressLabel = addressLabel
        
        let line2 = Theme.lineView()
        view.addSubview(line2)
        line2.snp_makeConstraints { make in
            make.top.equalTo(staticAddressLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
            make.height.equalTo(1)
//            make.width.equalTo(300)
        }
        
        let staticPhoneLabel = UILabel()
        staticPhoneLabel.text = NSLocalizedString("PROFILE_phone", comment: "")
        staticPhoneLabel.textColor = .staticGrayTextColor()
        staticPhoneLabel.textAlignment = .Left
        view.addSubview(staticPhoneLabel)
        staticPhoneLabel.snp_makeConstraints { make in
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.top.equalTo(line2.snp_bottom).offset(L.verticalSpacing)
        }
        
        let phoneLabel = UILabel()
        view.addSubview(phoneLabel)
        phoneLabel.textAlignment = .Right
        phoneLabel.snp_makeConstraints { make in
            make.left.greaterThanOrEqualTo(staticPhoneLabel.snp_right).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing).priorityLow()
            make.top.equalTo(line2.snp_bottom).offset(L.verticalSpacing)
        }
        self.phoneLabel = phoneLabel
        
        let aboutAppButton = Theme.grayButton()
        view.addSubview(aboutAppButton)
        aboutAppButton.setTitle(NSLocalizedString("PROFILE_about", comment: ""), forState: .Normal)
        aboutAppButton.snp_makeConstraints { make in
            make.height.equalTo(44)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
            make.bottom.equalTo(view).offset(-50)
        }
        self.aboutAppButton = aboutAppButton
        
    }
    
    weak var nameLabel: UILabel!
    weak var dateLabel: UILabel!
    weak var logoutButton: TintingButton!
    weak var emailLabel: UILabel!
    weak var addressLabel: UILabel!
    weak var phoneLabel: UILabel!
    weak var aboutAppButton: UIButton!

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    override func viewDidLoad() {
        logoutButton.setTitle(NSLocalizedString("PROFILE_logout", comment: ""), forState: .Normal)

        aboutAppButton.addTarget(self, action: "aboutAppPressed", forControlEvents: .TouchUpInside)
        
        showUser()
    }
    
    func updateLabels(myAccount: MyAccount) {
        nameLabel.text = myAccount.name
        emailLabel.text = myAccount.email
        addressLabel.text = myAccount.address
        phoneLabel.text = myAccount.phone
        dateLabel.text = dateLabelFormat(myAccount.membershipEnd)
    }
    
    let issueRequestPending = MutableProperty(false)
    func showUser() {
        API.myAccount().start(error: {error in
            self.handleError(error)
            }, completed: {
                self.issueRequestPending.value = false
            }, next: {myAccount in
                self.updateLabels(myAccount)
        })
    }
    
    func aboutAppPressed() {
        let aboutAppVC = AboutAppViewController()
        
        self.showViewController(aboutAppVC, sender: nil)
    }
    
    func dateLabelFormat(date: NSDate) -> String! {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        
        let stringDate = dateFormatter.stringFromDate(date)
        
        let str = NSLocalizedString("PROFILE_membership", comment: "") + stringDate
        return str
    }
    
    
}
