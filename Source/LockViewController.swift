//
//  ViewController.swift
//  ProjectName
//
//  Created by Dominik Vesely on 04/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import ReactiveCocoa



class LockViewController : UIViewController, UITextFieldDelegate/*, ErrorHandlerType*/, CLLocationManagerDelegate {
    
    override func loadView() {
        
        let view  = UIView()
        self.view = view
		setupKeyboardLayoutGuide()
		
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
            make.edges.equalTo(scrollView).inset(L.contentInsets) 
        }
        self.container = container
        
        let iv = UIImageView(image: UIImage(imageIdentifier: .logo))
		iv.contentMode = UIViewContentMode.ScaleAspectFit
        container.addSubview(iv)
        iv.snp_makeConstraints { make in
            make.top.equalTo(container).inset(L.contentInsets)
            make.left.equalTo(container).offset(20)
            make.right.equalTo(container).offset(-20)
            make.height.equalTo(150)
        }
        self.logoImageView = iv
        
        let titleLabel = Theme.titleLabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        titleLabel.textColor = .rekolaBlackColor()
        titleLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 17)
        container.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { make in
            make.left.right.equalTo(container).inset(L.contentInsets)
            make.top.equalTo(iv.snp_bottom).offset(L.verticalSpacing)
        }
        self.titleLabel = titleLabel
        
        let subtitleLabel = Theme.subTitleLabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .Center
        subtitleLabel.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 13)
        container.addSubview(subtitleLabel)
        subtitleLabel.snp_makeConstraints { make in
            make.left.right.equalTo(container).inset(L.contentInsets)
            make.top.equalTo(titleLabel.snp_bottom).offset(L.verticalSpacing)
        }
        self.subtitleLabel = subtitleLabel
        
        let textField = Theme.textField()
		textField.returnKeyType = .Done
        textField.textAlignment = .Center
        container.addSubview(textField)
        textField.snp_makeConstraints { make in
            make.height.equalTo(55)
            make.left.right.equalTo(container).inset(L.contentInsets)
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
        }
        self.textField = textField
        
        let borrowButton = Theme.pinkButton()
        container.addSubview(borrowButton)
        borrowButton.snp_makeConstraints { make in
            make.top.equalTo(textField.snp_bottom).offset(L.verticalSpacing)
            make.left.right.bottom.equalTo(container).inset(L.contentInsets)
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
		super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.tintColor = .rekolaGreenColor()
        self.view.backgroundColor = .whiteColor()
		
        titleLabel.text = NSLocalizedString("LOCK_codeInfo", comment: "")
        subtitleLabel.text = NSLocalizedString("LOCK_codeDescription", comment: "")
        textField.delegate = self
        textField.placeholder = NSLocalizedString("LOCK_enterCode", comment: "")
        borrowButton!.setTitle(NSLocalizedString("LOCK_borrow", comment: ""), forState: .Normal)
        borrowButton.addTarget(self, action: "borrowBike:", forControlEvents: .TouchUpInside)
		
		
		myBikeRequestPending.producer
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
		
		
		let tfHas6Digits = merge([textField.rac_textSignal().toSignalProducer(), textField.rac_valuesForKeyPath("text", observer: self).toSignalProducer()])
			|> ignoreError
			|> map { $0 as! String }
			|> map { (text : String) -> Bool in
				let expr = NSRegularExpression(pattern: "^[0-9]{6}$", options: .allZeros, error: nil)!
				let matches = expr.matchesInString(text, options: .allZeros, range: NSMakeRange(0, count(text)))
				return matches.count > 0
		}

		let hasLocation = location.producer |> map { $0 != nil }
		canBorrowBike <~ combineLatest([tfHas6Digits, myBikeRequestPending.producer, borrowRequestPending.producer, hasLocation])
			|> map { $0[0] && !$0[1] && !$0[2] && $0[3] }
			|> skipRepeats

		borrowButton.rac_enabled <~ canBorrowBike
		
		textField.delegate = self
		
		locationManager.requestWhenInUseAuthorization()
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationManager.delegate = self

		getMyBike()
		
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
		locationManager.startUpdatingLocation()
	}
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		locationManager.stopUpdatingLocation()
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
//		if(canBorrowBike.value) {
//			borrowBike(textField)
//		}
		textField.resignFirstResponder()
		return true
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		dispatch_async(dispatch_get_main_queue()) {
			self.scrollView.scrollToBottom(true)
		}
	}
	
	let myBikeRequestPending = MutableProperty(false)
	func getMyBike() {
		myBikeRequestPending.value = true
		API.myBike().start(error: { error in
			self.myBikeRequestPending.value = false
			self.handleError(error, severity: .UserAction, sender: self, userInfo: nil) //TODO: present alert with retry button?
//				{ [weak self] (result, handledBy) in
//				if(handledBy == self){
//					switch result {
//					case .AlertAction: //retry
//						self?.getMyBike()
//					default: fatalError("unexpected errorhandling result")
//					}
//				}
//			}
			self.getMyBike()
			
			}, completed: {
				self.myBikeRequestPending.value = false
			}, next: { bike in
				if let bike = bike {
					self.showBorrowedBikeController(bike, sender: self)
				}else {
					//do nothing, no borrowed bike
				}
			
		})
	}
	
	var canBorrowBike = MutableProperty(false)
	var borrowRequestPending = MutableProperty(false)
	func borrowBike(sender: AnyObject?) {
		UIView.performWithoutAnimation {
			textField.resignFirstResponder()
		}
		let code = textField.text
		borrowRequestPending.value = true
		API.borrowBike(code: code, location: location.value!).start(error: { error in
			self.borrowRequestPending.value = false
			self.handleError(error)
			}, next: { bike in
				self.borrowRequestPending.value = false
				logD("compl")
				self.showBorrowedBikeController(bike, sender: sender)
		})
		
    }

	func showBorrowedBikeController(bike: Bike, sender: AnyObject?) {
		let vc = BorrowedBikeViewController(bike: bike)
		showViewController(vc, sender: sender)
	}
	
	let location : MutableProperty<CLLocation?> = MutableProperty(nil)
	let locationManager = CLLocationManager()
	
	func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		//TODO: alert if status is .Restricted or .Denied
	}
	
	func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
		location.value = locationManager.location
	}
	
//	func errorHandlingStep(error: NSError, severity: ErrorSeverity, sender: AnyObject?, userInfo: [NSObject : AnyObject]?, completion: ErrorHandlerCompletion?) -> (hasCompletion: Bool, stop: Bool) {
//		if let statusCode = (error.userInfo?[APIErrorKeys.response] as? NSHTTPURLResponse)?.statusCode {
//			
//			return (false,true)
//		}
//		return (false, false)
//	}
	
}

