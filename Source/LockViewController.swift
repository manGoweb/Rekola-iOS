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
        
//        let textField = Theme.textField()
//		textField.returnKeyType = .Done
//        textField.keyboardType = UIKeyboardType.NumberPad
//        textField.textAlignment = .Center
//        container.addSubview(textField)
//        textField.snp_makeConstraints { make in
//            make.height.equalTo(55)
//            make.left.right.equalTo(container).inset(L.contentInsets)
//            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
//        }
//        self.textField = textField
        
        let tf1 = Theme.digitTextField()
        tf1.tag = 1
        tf1.text = " "
        tf1.hidden = true
        container.addSubview(tf1)
        tf1.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.equalTo(container).offset(8)
            make.height.equalTo(65)
            make.width.equalTo(48)
        }
        self.textField1 = tf1
        
        let tf2 = Theme.digitTextField()
        tf2.tag = 2
        tf2.hidden = true
        container.addSubview(tf2)
        tf2.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.equalTo(tf1.snp_right)
            make.height.equalTo(65)
            make.width.equalTo(48)
        }
        self.textField2 = tf2
        
        let tf3 = Theme.digitTextField()
        tf3.tag = 3
        tf3.hidden = true
        container.addSubview(tf3)
        tf3.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.equalTo(tf2.snp_right)
            make.height.equalTo(65)
            make.width.equalTo(48)
        }
        self.textField3 = tf3
        
        let tf4 = Theme.digitTextField()
        tf4.tag = 4
        tf4.hidden = true
        container.addSubview(tf4)
        tf4.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.equalTo(tf3.snp_right)
            make.height.equalTo(65)
            make.width.equalTo(48)
        }
        self.textField4 = tf4
        
        let tf5 = Theme.digitTextField()
        tf5.tag = 5
        tf5.hidden = true
        container.addSubview(tf5)
        tf5.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.equalTo(tf4.snp_right)
            make.height.equalTo(65)
            make.width.equalTo(48)
        }
        self.textField5 = tf5
        
        let tf6 = Theme.digitTextField()
        tf6.tag = 6
        container.addSubview(tf6)
        tf6.hidden = true
        tf6.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.equalTo(tf5.snp_right)
//            make.right.equalTo(container).offset(-L.horizontalSpacing)
            make.height.equalTo(65)
            make.width.equalTo(48)
        }
        self.textField6 = tf6
        
        let textFieldButton = UIButton()
        container.addSubview(textFieldButton)
        textFieldButton.setBackgroundImage(UIImage(color: .rekolaGrayTextFieldColor()), forState: UIControlState.Normal)
        textFieldButton.setTitle(NSLocalizedString("LOCK_enterCode", comment: ""), forState: UIControlState.Normal)
        textFieldButton.titleLabel?.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 17)
        textFieldButton.setTitleColor(.rekolaGrayTextColor(), forState: .Normal)
        textFieldButton.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.right.equalTo(view).inset(L.contentInsets)
            make.height.equalTo(65)
        }
        self.textFieldButton = textFieldButton
        
        let borrowButton = Theme.pinkButton()
        container.addSubview(borrowButton)
        borrowButton.titleLabel?.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 17)
        borrowButton.snp_makeConstraints { make in
            make.top.equalTo(textFieldButton.snp_bottom).offset(L.verticalSpacing)
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
    weak var textField1: UITextField!
    weak var textField2: UITextField!
    weak var textField3: UITextField!
    weak var textField4: UITextField!
    weak var textField5: UITextField!
    weak var textField6: UITextField!
    weak var textFieldButton: UIButton!
    
    
//    weak var textField: UITextField!
    weak var borrowButton : UIButton!
    
    
    override func viewDidLoad() {
		super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.tintColor = .rekolaGreenColor()
        self.view.backgroundColor = .whiteColor()
		
        titleLabel.text = NSLocalizedString("LOCK_codeInfo", comment: "")
        subtitleLabel.text = NSLocalizedString("LOCK_codeDescription", comment: "")
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        textField4.delegate = self
        textField5.delegate = self
        textField6.delegate = self
        
        textFieldButton.addTarget(self, action: "enterCode:", forControlEvents: UIControlEvents.TouchUpInside)
        
        textField1.addTarget(self, action: "changeTextField:", forControlEvents: UIControlEvents.EditingChanged)
        textField2.addTarget(self, action: "changeTextField:", forControlEvents: UIControlEvents.EditingChanged)
        textField3.addTarget(self, action: "changeTextField:", forControlEvents: UIControlEvents.EditingChanged)
        textField4.addTarget(self, action: "changeTextField:", forControlEvents: UIControlEvents.EditingChanged)
        textField5.addTarget(self, action: "changeTextField:", forControlEvents: UIControlEvents.EditingChanged)
        textField6.addTarget(self, action: "changeTextField:", forControlEvents: UIControlEvents.EditingChanged)
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)
        
//        textField.font = UIFont(name: Theme.SFFont.Bold.rawValue, size: 20)
//        textField.placeholder = NSLocalizedString("LOCK_enterCode", comment: "")
        
        borrowButton!.setTitle(NSLocalizedString("LOCK_borrow", comment: ""), forState: .Normal)
        borrowButton.addTarget(self, action: "borrowBike:", forControlEvents: .TouchUpInside)
		
		
//        progressHud
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
		
		
//		let tfHas6Digits = merge([textField.rac_textSignal().toSignalProducer(), textField.rac_valuesForKeyPath("text", observer: self).toSignalProducer()])
//			|> ignoreError
//			|> map { $0 as! String }
//			|> map { (text : String) -> Bool in
//				let expr = NSRegularExpression(pattern: "^[0-9]{6}$", options: .allZeros, error: nil)!
//				let matches = expr.matchesInString(text, options: .allZeros, range: NSMakeRange(0, count(text)))
//				return matches.count > 0
//		}

//		let hasLocation = location.producer |> map { $0 != nil }
//		canBorrowBike <~ combineLatest([tfHas6Digits, myBikeRequestPending.producer, borrowRequestPending.producer, hasLocation])
//			|> map { $0[0] && !$0[1] && !$0[2] && $0[3] }
//			|> skipRepeats
//
//		borrowButton.rac_enabled <~ canBorrowBike
				
		locationManager.requestWhenInUseAuthorization()
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationManager.delegate = self

		getMyBike()
		
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
		locationManager.startUpdatingLocation()
        self.logoImageView.alpha = 1

	}
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		locationManager.stopUpdatingLocation()
	}
    
    
    func enterCode(sender: UIButton) {
        sender.hidden = true
        textField1.hidden = false
        textField2.hidden = false
        textField3.hidden = false
        textField4.hidden = false
        textField5.hidden = false
        textField6.hidden = false
        
        textField1.becomeFirstResponder()
    }
/**
    forward navigation in textfields; in the following textfield put whitespace for better navigation backwards
*/
    func changeTextField(sender: AnyObject?) {
        let textField = sender as! UITextField
        let nextTag = textField.tag + 1
        println("TAG prev: \(textField.tag) \n next: \(nextTag)")
        if let nextResponder = textField.superview!.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
            let tf = nextResponder as! UITextField
            if tf.text == "" {
                tf.text = " "
            }
            
        } else {
            textField.resignFirstResponder()
            self.logoImageView.alpha = 1
        }
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.logoImageView.alpha = 1
    }
    
    func createPasscode() -> String{
        let hundredThousand = textField1.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        let tensThousand = textField2.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        let thousands = textField3.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        let hundreds = textField4.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        let tens = textField5.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        let ones = textField6.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let passcode = hundredThousand + tensThousand + thousands + hundreds + tens + ones
        
//        delete textfields
        textField1.text = ""
        textField2.text = ""
        textField3.text = ""
        textField4.text = ""
        textField5.text = ""
        textField6.text = ""
        
        textField1.hidden = true
        textField2.hidden = true
        textField3.hidden = true
        textField4.hidden = true
        textField5.hidden = true
        textField6.hidden = true
        
        textFieldButton.hidden = false
        
        return passcode
    }
    
//    API calling + segue to BikeDetailViewController
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
            //self.getMyBike()
            
            }, completed: {
                self.myBikeRequestPending.value = false
            }, next: { bike in
                if let bike = bike {
                    self.showBorrowedBikeController(bike, sender: self)
                }else {
                    self.logoImageView.alpha = 1
                }
                
        })
    }
    
    var canBorrowBike = MutableProperty(false)
    var borrowRequestPending = MutableProperty(false)
    func borrowBike(sender: AnyObject?) {
        UIView.performWithoutAnimation {
            //			textField.resignFirstResponder()
        }
        let code = createPasscode() //textField.text
        borrowRequestPending.value = true
        if let coords = location.value {
            API.borrowBike(code: code, location: coords).start(error: { error in
                self.borrowRequestPending.value = false
                self.handleError(error)
                }, next: { bike in
                    self.borrowRequestPending.value = false
                    logD("compl")
                    self.showBorrowedBikeController(bike, sender: sender)
            })
        } else {
            let alertView = UIAlertView(title: NSLocalizedString("LOCK_coordinate", comment: ""), message: "", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
        

        
    }
    
    func showBorrowedBikeController(bike: Bike, sender: AnyObject?) {
        let vc = BorrowedBikeViewController(bike: bike)
        showViewController(vc, sender: sender)
    }


    
//    MARK: UITextFieldDelegate
    
//	func textFieldShouldReturn(textField: UITextField) -> Bool {
////		if(canBorrowBike.value) {
////			borrowBike(textField)
////		}
//		textField.resignFirstResponder()
//
//		return true
//	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		dispatch_async(dispatch_get_main_queue()) {
			self.scrollView.scrollToBottom(true)
//            self.logoImageView.alpha = 0
		}
	}
		
/*    backward navigation in textFields; first if handles situation, when user clicked to the one of the middle textfields and want to go backwards
      "else if" handles situation, when user want to delete last digit he wrotes, and else handle situation when user wants to delete whole passcode*/
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text == " " && string == "" {
            let previousTag = textField.tag - 1
            if let previousResponder = textField.superview!.viewWithTag(previousTag) {
                if previousTag > 0 {
                    previousResponder.becomeFirstResponder()
                    let tf = previousResponder as! UITextField
                    tf.text = " "
                } else {
                    textField.resignFirstResponder()
                }
            } else {
                textField.resignFirstResponder()
            }
            return false
        } else if textField.text != " " && string != "" {
            changeTextField(textField)
        } else if textField.text != " " && textField.text != "" {
            textField.text = ""
            let previousTag = textField.tag - 1
            if let previousResponder = textField.superview!.viewWithTag(previousTag) {
                if previousTag > 0 {
                    previousResponder.becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
            } else {
                textField.resignFirstResponder()
            }
            
            return false
        }
        else {
            textField.text = ""
        }
        return true
    }
    
//    MARK: CLLocationManagerDelegate
    
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

