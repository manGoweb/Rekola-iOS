//
//  SignInViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 07/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UIApplicationDelegate {
	override func loadView() {
		let view = UIView()
		view.backgroundColor = .rekolaPinkColor()
		self.view = view
		
		let iv = UIImageView(image: UIImage(imageIdentifier: .signInBike))
		iv.contentMode = .ScaleAspectFit
		view.addSubview(iv)
		iv.snp_makeConstraints { make in
			make.top.equalTo(view).offset(60).priority(500)
			make.left.equalTo(view).offset(L.horizontalSpacing)
			make.right.equalTo(view).offset(-L.horizontalSpacing)
		}
		self.bikeImageView = iv
		
		let emailTF = Theme.pinkTextField()
		view.addSubview(emailTF)
		emailTF.snp_makeConstraints { make in
			make.top.equalTo(iv.snp_bottom).offset(L.verticalSpacing)//.priority(250)
			make.left.equalTo(view).offset(L.horizontalSpacing)
			make.right.equalTo(view).offset(-L.horizontalSpacing)
			make.height.equalTo(43)
		}
		self.emailTextField = emailTF
		
		let passwdTF = Theme.pinkTextField()
		view.addSubview(passwdTF)
		passwdTF.snp_makeConstraints { make in
			make.top.equalTo(emailTF.snp_bottom).offset(L.verticalSpacing)
			make.right.equalTo(view).offset(-L.horizontalSpacing)
			make.left.equalTo(view).offset(L.horizontalSpacing)
			make.height.equalTo(43)
		}
		self.passwordTextField = passwdTF
		
		let signInButton = Theme.whiteButton()
		signInButton.backgroundColor = .whiteColor()
		signInButton.layer.cornerRadius = 4
		view.addSubview(signInButton)
		signInButton.snp_makeConstraints { make in
			make.top.equalTo(passwdTF.snp_bottom).offset(L.verticalSpacing)
			make.left.equalTo(view).offset(L.horizontalSpacing)
			make.right.equalTo(view).offset(-L.horizontalSpacing)
			make.height.equalTo(47)
		}
		self.signInButton = signInButton
		
		let register = UIButton()
		register.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		register.titleLabel?.font = UIFont.systemFontOfSize(14)
		view.addSubview(register)
		register.snp_makeConstraints { make in
			make.top.equalTo(signInButton.snp_bottom).offset(L.verticalSpacing)
			make.left.right.equalTo(view)
		}
		self.registerButton = register
		
		let forgotPasswd = UIButton()
		forgotPasswd.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		forgotPasswd.titleLabel?.font = UIFont.systemFontOfSize(14)
		view.addSubview(forgotPasswd)
		forgotPasswd.snp_makeConstraints { make in
			make.top.equalTo(register.snp_bottom)
			make.left.right.equalTo(view)
			make.bottom.lessThanOrEqualTo(keyboardLayoutGuide)
		}
		self.forgotPasswd = forgotPasswd
		
		let ackeeIm = UIImageView(image: UIImage(imageIdentifier: .ackee))
		view.addSubview(ackeeIm)
		ackeeIm.snp_makeConstraints { make in
			make.top.equalTo(forgotPasswd.snp_bottom).offset(L.verticalSpacing)
			make.left.right.equalTo(view)
		}
		self.ackeeImage = ackeeIm
	}
	
	
	weak var bikeImageView: UIImageView!
	weak var emailTextField: UITextField!
	weak var passwordTextField: UITextField!
	weak var signInButton: UIButton!
	weak var registerButton: UIButton!
	weak var forgotPasswd: UIButton!
	weak var ackeeImage: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		UIApplication.sharedApplication().statusBarStyle = .LightContent
		
		self.emailTextField.attributedPlaceholder = NSAttributedString(string:"Email",
			attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
		
		self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"Heslo",
			attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
		
		self.signInButton.setTitle("Přihlásit se", forState: .Normal)
		self.signInButton.addTarget(self, action: "signIn:", forControlEvents: .TouchUpInside)
		
		self.registerButton.setTitle("Registrovat se", forState: .Normal)
		
		self.forgotPasswd.setTitle("Zapomenuté heslo", forState: .Normal)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
//		UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	func signIn(sender: AnyObject?) {
		
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		
		let vc = UINavigationController(rootViewController: LockViewController())
		let vc2 = UINavigationController(rootViewController: MapViewController())
		let vc3 = UINavigationController(rootViewController: ProfileViewController())
		
		let item = TabItem(controller: vc, images: UIImage.toggleImage(UIImage.ImagesForToggle.Lock))
		let item2 = TabItem(controller: vc2, images: UIImage.toggleImage(UIImage.ImagesForToggle.Map))
		let item3 = TabItem(controller: vc3, images: UIImage.toggleImage(UIImage.ImagesForToggle.Profile))
		
		let tabBar = ACKTabBarController(items: [item,item2,item3])
		delegate.window!.rootViewController = tabBar
		
		tabBar.view.alpha = 0.0
		UIView.animateWithDuration(0.2, animations: { () -> Void in
			tabBar.view.alpha = 1.0
		})
		
		delegate.window!.makeKeyAndVisible()
		
	}
}
