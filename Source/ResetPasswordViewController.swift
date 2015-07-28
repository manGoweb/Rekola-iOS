//
//  ResetPasswordViewController.swift
//  Rekola
//
//  Created by Petr Šíma on Jul/28/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ResetPasswordViewController : UIViewController, UITextFieldDelegate {
	
	override func loadView() {
		let view = UIView()
		view.backgroundColor = .whiteColor()
		view.opaque = true
		self.view = view

		
		
		
		let backButton = Theme.whiteButton()
		backButton.titleLabel?.font = UIFont.systemFontOfSize(14)
		view.addSubview(backButton)
		backButton.snp_makeConstraints { make in
			make.bottom.equalTo(keyboardLayoutGuide).offset(-L.contentInsets.bottom)
			make.right.equalTo(view).insets(L.contentInsets)
		}
		self.backButton = backButton
		
		let scrollView = UIScrollView()
		view.addSubview(scrollView)
		scrollView.snp_makeConstraints { make in
			make.left.right.equalTo(view)
			make.top.equalTo(snp_topLayoutGuideBottom)
			make.bottom.equalTo(backButton.snp_top)
		}
		self.scrollView = scrollView
		
		let resetButton = Theme.pinkButton()
		scrollView.addSubview(resetButton)
		resetButton.snp_makeConstraints { make in
			make.bottom.equalTo(scrollView).offset(-L.verticalSpacing)
			make.bottom.equalTo(backButton.snp_top).offset(-150).priorityLow()
			make.left.right.equalTo(view).insets(L.contentInsets)
			make.height.equalTo(43)
		}
		self.resetButton = resetButton
		
		
		
		let emailTextField = Theme.textField()
		emailTextField.textAlignment = .Center
		scrollView.addSubview(emailTextField)
		emailTextField.snp_makeConstraints { make in
			make.bottom.equalTo(resetButton.snp_top).offset(-L.verticalSpacing)
			make.left.right.equalTo(resetButton)
			make.height.equalTo(43)
		}
		self.emailTextField = emailTextField
	
		let subtitleLabel = Theme.subTitleLabel()
		subtitleLabel.textAlignment = .Center
		subtitleLabel.numberOfLines = 0
		scrollView.addSubview(subtitleLabel)
		subtitleLabel.snp_makeConstraints { make in
			make.bottom.equalTo(emailTextField.snp_top).offset(-L.verticalSpacing)
			make.left.right.equalTo(view).insets(UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30))
		}
		self.subtitleLabel = subtitleLabel
		
		
		let titleLabel = Theme.titleLabel()
		titleLabel.textAlignment = .Center
		scrollView.addSubview(titleLabel)
		titleLabel.snp_makeConstraints { make in
			make.left.right.equalTo(view).insets(L.contentInsets)
			make.bottom.equalTo(subtitleLabel.snp_top).offset(-L.verticalSpacing)
			make.top.greaterThanOrEqualTo(scrollView).offset(L.contentInsets.top)
		}
		self.titleLabel = titleLabel
	}
	
	
	weak var scrollView : UIScrollView!
	weak var titleLabel : UILabel!
	weak var subtitleLabel : UILabel!
	weak var emailTextField : UITextField!
	weak var resetButton : UIButton!
	weak var backButton : UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		titleLabel.text = NSLocalizedString("PASSWORD_RESET_TITLE", comment: "")
		subtitleLabel.text = NSLocalizedString("PASSWORD_RESET_SUBTITLE", comment: "")
		emailTextField.placeholder = NSLocalizedString("EMAIL", comment: "")
		resetButton.setTitle(NSLocalizedString("PASSWORD_RESET_BUTTON", comment: ""), forState: .Normal)
		backButton.setTitle(NSLocalizedString("PASSWORD_RESET_BACK", comment: ""), forState: .Normal)
		
		resetButton.addTarget(self, action: "reset:", forControlEvents: .TouchUpInside)
		backButton.addTarget(self, action: "back:", forControlEvents: .TouchUpInside)
		
		let emailEmpty = merge([emailTextField.rac_textSignal().toSignalProducer(), emailTextField.rac_valuesForKeyPath("text", observer: self).toSignalProducer()])
			|> ignoreError
			|> map { ($0 as! String).isEmpty }
		resetButton.rac_enabled <~ combineLatest([emailEmpty, resetPending.producer]) |> map { !($0[0] || $0[1]) }
		
		emailTextField.returnKeyType = UIReturnKeyType.Send
		emailTextField.delegate = self
	}
	
	var resetPending = MutableProperty(false)
	
	func reset(sender: AnyObject?) {
		resetPending.value = true
		API.passwordRecovery(email: emailTextField.text).start(error: { error in
			self.resetPending.value = false
			self.handleError(error)
			}, completed: {
			self.resetPending.value = false
			self.back(self)
		})
	}
	
	func back(sender : AnyObject?) {
		view.endEditing(true)
		presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		dispatch_async(dispatch_get_main_queue()) { //after keyboard has shown
			let scrollView = self.scrollView
			if(scrollView.contentSize.height > scrollView.bounds.size.height){
				scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height), animated: true)
			}
		}
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		if(resetButton.enabled) {//app logic shouldnt be dependent on view state, but im lazy
			reset(textField)
		}
		return true
	}
}
