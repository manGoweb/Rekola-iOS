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
        nameLabel.text = " "
        nameLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 26)
        nameLabel.textAlignment = .Center
        nameLabel.snp_makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(70)
            }
        self.nameLabel = nameLabel
        
        let dateLabel = UILabel()
        view.addSubview(dateLabel)
        dateLabel.text = " "
        dateLabel.textColor = .rekolaPinkColor()
        dateLabel.textAlignment = .Center
        dateLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 15)
        dateLabel.snp_makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(nameLabel.snp_bottom).offset(5)
        }
        self.dateLabel = dateLabel
        
        let logoutButton = TintingButton(titleAndImageTintedWith: .rekolaGreenColor(), activeTintColor: UIColor.whiteColor())
        view.addSubview(logoutButton)
        logoutButton.setImage(UIImage(imageIdentifier: .logoutButton), forState: .Normal)
        logoutButton.layer.borderColor = UIColor.rekolaGreenColor().CGColor
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.cornerRadius = 4
        logoutButton.titleLabel?.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 17)
        logoutButton.snp_makeConstraints { make in
            make.width.equalTo(169)
            make.height.equalTo(44)
            make.top.equalTo(dateLabel.snp_bottom).offset(20)
            make.centerX.equalTo(view.snp_centerX)
        }
        self.logoutButton = logoutButton
        
        let staticEmailLabel = UILabel()
        staticEmailLabel.text = NSLocalizedString("PROFILE_email", comment: "")
        staticEmailLabel.textColor = .staticGrayTextColor()
        staticEmailLabel.textAlignment = .Left
        staticEmailLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 15)
        view.addSubview(staticEmailLabel)
        staticEmailLabel.snp_makeConstraints { make in
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.top.equalTo(logoutButton.snp_bottom).offset(30)
        }
        
        let emailLabel = UILabel()
        view.addSubview(emailLabel)
        emailLabel.textAlignment = .Right
        emailLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 15)
        emailLabel.snp_makeConstraints { make in
            make.left.greaterThanOrEqualTo(staticEmailLabel.snp_right).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing).priorityLow()
            make.top.equalTo(logoutButton.snp_bottom).offset(30)
        }
        self.emailLabel = emailLabel
        
        let line1 = Theme.lineView()
        view.addSubview(line1)
        line1.snp_makeConstraints { make in
            make.top.equalTo(staticEmailLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
            make.height.equalTo(1)
//            make.width.equalTo(300)
        }
        
        let staticAddressLabel = UILabel()
        staticAddressLabel.text = NSLocalizedString("PROFILE_address", comment: "")
        staticAddressLabel.textColor = .staticGrayTextColor()
        staticAddressLabel.textAlignment = .Left
        staticAddressLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 15)
        view.addSubview(staticAddressLabel)
        staticAddressLabel.snp_makeConstraints { make in
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.top.equalTo(line1.snp_bottom).offset(L.verticalSpacing)
        }
        
        let addressLabel = UILabel()
        view.addSubview(addressLabel)
        addressLabel.textAlignment = .Left
        addressLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 15)
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
        staticPhoneLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 15)
        view.addSubview(staticPhoneLabel)
        staticPhoneLabel.snp_makeConstraints { make in
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.top.equalTo(line2.snp_bottom).offset(L.verticalSpacing)
        }
        
        let phoneLabel = UILabel()
        view.addSubview(phoneLabel)
        phoneLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 15)
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
            make.left.right.equalTo(view).inset(L.contentInsets)
            make.bottom.equalTo(view).offset(-30)
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
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        logoutButton.setTitle(NSLocalizedString("PROFILE_logout", comment: ""), forState: .Normal)
        logoutButton.addTarget(self, action: "logout:", forControlEvents: .TouchUpInside)
        aboutAppButton.addTarget(self, action: "aboutAppPressed", forControlEvents: .TouchUpInside)
        
        showUser()
        issueRequestPending.producer
            |> skipRepeats { (prev, curr) in
                return 	prev == curr
            }
            |> start(next: { [weak self] in
                if $0{
                    self?.view.userInteractionEnabled = false
                    SVProgressHUD.show()
                } else {
                    self?.view.userInteractionEnabled = true
                    SVProgressHUD.dismiss()
                }
                })
    }
    
    let logoutRequestPending = MutableProperty(false)
    func logout(sender: AnyObject?) {
        logoutRequestPending.value = true
        API.logout().start(error: { error in
            self.logoutRequestPending.value = false
            self.handleError(error)
            }, completed: { [weak self] in
                self?.logoutRequestPending.value = false
                
                NSUserDefaults.standardUserDefaults().removeObjectForKey("apiKey")
                
                let signIn = SignInViewController()
                let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                delegate.window?.rootViewController = signIn
                delegate.window!.makeKeyAndVisible()
        })
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
            }, completed: { [weak self] in
                self?.issueRequestPending.value = false
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
        dateFormatter.dateFormat = "dd. MM. YYYY"
        
        let stringDate = dateFormatter.stringFromDate(date)
        
        let str = NSLocalizedString("PROFILE_membership", comment: "") + stringDate
        return str
    }
    
    
}
