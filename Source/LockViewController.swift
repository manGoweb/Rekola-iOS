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
    
        
        let tf1 = Theme.digitTextField()
        tf1.tag = 1
        tf1.text = " "
        tf1.hidden = true
        container.addSubview(tf1)
        tf1.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.equalTo(container).offset(1)
            make.height.equalTo(65)
            make.width.equalTo(50)
        }
        self.textField1 = tf1
        
        let dot1 = Theme.circle()
        textField1.addSubview(dot1)
        dot1.snp_makeConstraints { make in
            make.bottom.equalTo(tf1.snp_bottom).offset(-18)
            make.left.equalTo(container).offset(45)
            make.height.equalTo(5)
            make.width.equalTo(5)
        }
        
        let tf2 = Theme.digitTextField()
        tf2.tag = 2
        tf2.hidden = true
        container.addSubview(tf2)
        tf2.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.equalTo(tf1.snp_right)
            make.height.equalTo(65)
            make.width.equalTo(50)
        }
        self.textField2 = tf2
        
        let dot2 = Theme.circle()
        textField2.addSubview(dot2)
        dot2.snp_makeConstraints { make in
            make.bottom.equalTo(tf2.snp_bottom).offset(-18)
            make.left.equalTo(dot1.snp_right).offset(45)
            make.height.equalTo(5)
            make.width.equalTo(5)
        }
        
        
        let tf3 = Theme.digitTextField()
        tf3.tag = 3
        tf3.hidden = true
        container.addSubview(tf3)
        tf3.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.equalTo(tf2.snp_right)
            make.height.equalTo(65)
            make.width.equalTo(50)
        }
        self.textField3 = tf3
        
        let dot3 = Theme.circle()
        textField3.addSubview(dot3)
        dot3.snp_makeConstraints { make in
            make.bottom.equalTo(textField3.snp_bottom).offset(-18)
            make.left.equalTo(dot2.snp_right).offset(45)
            make.height.equalTo(5)
            make.width.equalTo(5)
        }
        
        let tf4 = Theme.digitTextField()
        tf4.tag = 4
        tf4.hidden = true
        container.addSubview(tf4)
        tf4.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.equalTo(tf3.snp_right)
            make.height.equalTo(65)
            make.width.equalTo(50)
        }
        self.textField4 = tf4
        
        let dot4 = Theme.circle()
        textField4.addSubview(dot4)
        dot4.snp_makeConstraints {make in
            make.bottom.equalTo(textField4.snp_bottom).offset(-18)
            make.left.equalTo(dot3.snp_right).offset(45)
            make.width.equalTo(5)
            make.height.equalTo(5)
        }
        
        let tf5 = Theme.digitTextField()
        tf5.tag = 5
        tf5.hidden = true
        container.addSubview(tf5)
        tf5.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.equalTo(tf4.snp_right)
            make.height.equalTo(65)
            make.width.equalTo(50)
        }
        self.textField5 = tf5
        
        let dot5 = Theme.circle()
        textField5.addSubview(dot5)
        dot5.snp_makeConstraints { make in
            make.bottom.equalTo(textField5.snp_bottom).offset(-18)
            make.left.equalTo(dot4.snp_right).offset(45)
            make.height.equalTo(5)
            make.width.equalTo(5)
        }
        
        let tf6 = Theme.digitTextField()
        tf6.tag = 6
        container.addSubview(tf6)
        tf6.hidden = true
        tf6.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.equalTo(tf5.snp_right)
//            make.right.equalTo(container).offset(-L.horizontalSpacing)
            make.height.equalTo(65)
            make.width.equalTo(50)
        }
        self.textField6 = tf6
        
        let textFieldButton = UIButton()
        container.addSubview(textFieldButton)
        textFieldButton.setBackgroundImage(UIImage(color: .rekolaGrayTextFieldColor()), forState: UIControlState.Normal)
        textFieldButton.setTitle(NSLocalizedString("LOCK_enterCode", comment: ""), forState: UIControlState.Normal)
        textFieldButton.titleLabel?.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 17)
        textFieldButton.titleLabel?.textAlignment = NSTextAlignment.Center
        textFieldButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center;
        

        textFieldButton.setTitleColor(.rekolaGrayTextColor(), forState: .Normal)
        textFieldButton.snp_makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp_bottom).offset(20)
            make.left.right.equalTo(container)
            make.height.equalTo(65)
        }
        self.textFieldButton = textFieldButton
        
        let borrowButton = Theme.pinkButton()
        container.addSubview(borrowButton)
        borrowButton.titleLabel?.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 22)
            borrowButton.snp_makeConstraints { make in
            make.top.equalTo(textFieldButton.snp_bottom).offset(L.verticalSpacing)
            make.left.right.bottom.equalTo(container)
            make.height.equalTo(59)
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
    
    var textFields : [UITextField]!
    
    
//    weak var textField: UITextField!
    weak var borrowButton : UIButton!
    
    
    override func viewDidLoad() {
		super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.tintColor = .rekolaGreenColor()
        self.view.backgroundColor = .whiteColor()
        
        textFields = [textField1,textField2,textField3,textField4,textField5,textField6,]
		
        titleLabel.text = NSLocalizedString("LOCK_codeInfo", comment: "")
        subtitleLabel.text = NSLocalizedString("LOCK_codeDescription", comment: "")
        textFields.map { $0.delegate = self }
        textFieldButton.addTarget(self, action: "enterCode:", forControlEvents: UIControlEvents.TouchUpInside)
        textFields.map { $0.addTarget(self, action: "changeTextField:", forControlEvents: UIControlEvents.EditingChanged) }
        
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)
        
        
        borrowButton!.setTitle(NSLocalizedString("LOCK_borrow", comment: ""), forState: .Normal)
        borrowButton.addTarget(self, action: "borrowBike:", forControlEvents: .TouchUpInside)
		
		
        scrollView.scrollEnabled = false
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
		
						
		locationManager.requestWhenInUseAuthorization()
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationManager.delegate = self

		getMyBike()
		
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
		locationManager.startUpdatingLocation()
        hideTextfields()
	}
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		locationManager.stopUpdatingLocation()
	}
    
    func enterCode(sender: UIButton) {
        sender.hidden = true
        UIView.animateWithDuration(0.5) { self.logoImageView.alpha = 0 }
        textFields.map { $0.hidden = false}
        textFields.map { $0.text = ""}
        textField1.userInteractionEnabled = true
        textField1.becomeFirstResponder()
        
        self.scrollView.scrollToBottom(true)

    }
    
/**
    forward navigation in textfields; in the following textfield puts whitespace for better navigation backwards
*/
    func changeTextField(sender: AnyObject?) {
        let textField = sender as! UITextField
        let nextTag = textField.tag + 1
        println("TAG prev: \(textField.tag) \n next: \(nextTag)")
        if let nextResponder = textField.superview!.viewWithTag(nextTag) {
            nextResponder.userInteractionEnabled = true
           // nextResponder.becomeFirstResponder()
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.0)
            UIView.setAnimationDelay(0)
            UIView.setAnimationCurve(UIViewAnimationCurve.Linear)
            nextResponder.becomeFirstResponder()
            textField.userInteractionEnabled = false
            UIView.commitAnimations();
            
            let tf = nextResponder as! UITextField
            if tf.text == "" {
                tf.text = " "
            }
            
        } else {
            textField.resignFirstResponder()
            hideTextfields()
        }
    }
    
    func hideTextfields() {
        
        textFields.map { $0.hidden = true}
        textFieldButton.hidden = false
        UIView.animateWithDuration(0.5) { self.logoImageView.alpha = 1 }

        let passcode = createPasscode()
        if count(passcode) == 6 {
            textFieldButton.setTitle(passcode, forState: UIControlState.Normal)
            textFieldButton.titleLabel?.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 40)
            
            let atributes = NSAttributedString(string: passcode, attributes: [NSKernAttributeName: (10)])
            textFieldButton.titleLabel?.attributedText = atributes
        } else {
            textFieldButton.setTitle(NSLocalizedString("LOCK_enterCode", comment: ""), forState: UIControlState.Normal)
            textFieldButton.titleLabel?.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 17)
        }
        
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        hideTextfields()
        
    }
    
    func createPasscode() -> String{
        let hundredThousand = self.textField1.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        let tensThousand = textField2.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        let thousands = textField3.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        let hundreds = textField4.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        let tens = textField5.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        let ones = textField6.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let passcode = hundredThousand + tensThousand + thousands + hundreds + tens + ones
        
        textFields.map { $0.hidden = true}
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
            API.borrowBike(code: code, location: coords).start(
                error: { error in
                    self.borrowRequestPending.value = false
                    self.handleError(error)
                },
                completed: {  textFields.map { $0.text = ""} } ,
                next: { bike in
                    self.borrowRequestPending.value = false
                    self.showBorrowedBikeController(bike, sender: sender)
            })
        } else {
            let alertView = UIAlertView(title: NSLocalizedString("LOCK_coordinate", comment: ""), message: "", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            textFields.map { $0.text = ""}

        }
        

        
    }
    
    func showBorrowedBikeController(bike: Bike, sender: AnyObject?) {
        let vc = BorrowedBikeViewController(bike: bike)
        showViewController(vc, sender: sender)
    }


/*    backward navigation in textFields; first if handles situation, when user clicked to the one of the middle textfields and want to go backwards
      "else if" handles situation, when user want to delete last digit he wrotes, and else handle situation when user wants to delete whole passcode*/
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text == " " && string == "" {
            let previousTag = textField.tag - 1
            if let previousResponder = textField.superview!.viewWithTag(previousTag) {
                if previousTag > 0 {
                    previousResponder.userInteractionEnabled = true
                    
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
        } else {
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

