//
//  KeyboardLayoutGuide.swift
//  ProjectName
//
//  Created by Petr Šíma on Jun/25/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import ObjectiveC
import SnapKit
import ReactiveCocoa
//TODO: change to UILayoutGuide for ios9

private var onceToken: dispatch_once_t = 0

extension UIViewController {
	
	private struct AssociatedKeys {
		static var KeyboardLayoutGuide = "keyboardLayoutGuide"
	}
	
	var keyboardLayoutGuide : UIView! {
		return objc_getAssociatedObject(self, &AssociatedKeys.KeyboardLayoutGuide) as! UIView
	}
	
	override public class func initialize() { //TODO: does this break UIViewController class?
		super.initialize()
		
		dispatch_once(&onceToken) {
			var ok = self.swizzleMethodSelector("setView:", withSelector: "kblg_setView:", forClass: UIViewController.classForCoder())
			if(!ok) { logA("cant setup keyboard layoutguide") }
		}
	}
	
	@objc func kblg_setView(view: UIView) {
		kblg_setView(view)
		
		let guide = UIView()
		view.addSubview(guide)
		var c : ConstraintDescriptionEditable!
		guide.snp_remakeConstraints { make in
			make.height.equalTo(0)
			make.left.right.equalTo(view)
			c = make.bottom.equalTo(view).offset(0)
		}

		objc_setAssociatedObject(self, &AssociatedKeys.KeyboardLayoutGuide, guide, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC)) //held strongly, cant do weak ref easily
		
		let show = NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillShowNotification, object: nil).toSignalProducer()
			|> ignoreError
			|> map { (note : AnyObject?) -> (height: CGFloat, duration: Double, curve: UIViewAnimationCurve)? in
				if let userInfo = (note as? NSNotification)?.userInfo {
					let rect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
					let rectInSelf = view.convertRect(rect, fromView: UIApplication.sharedApplication().keyWindow)
					let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
					let curve = UIViewAnimationCurve(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue)!
					return (height: view.bounds.size.height - rectInSelf.origin.y, duration: duration, curve: curve)
				}
				return nil
			}
			|> ignoreNil
		
		let hide = NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillHideNotification, object: nil).toSignalProducer()
			|> ignoreError
			|> map { (note : AnyObject?) -> (height: CGFloat, duration: Double, curve: UIViewAnimationCurve)? in
				if let userInfo = (note as? NSNotification)?.userInfo {
					let rect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
					let rectInSelf = view.convertRect(rect, fromView: UIApplication.sharedApplication().keyWindow)
					let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
										let curve = UIViewAnimationCurve(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue)!
					return (height: view.bounds.size.height - rectInSelf.origin.y, duration: duration, curve: curve)
				}
				return nil
			}
			|> ignoreNil
		
		let height = merge([show, hide/*, changeFrame*/])
		height.start(next: {
			c.constraint.updateOffset(-$0.height)
			UIView.animateWithDuration($0.duration) {
				view.layoutIfNeeded()
			}
		})

		
		
		let appear = rac_signalForSelector("viewWillAppear:").toSignalProducer()
			|> ignoreError
			|> map { _ in true }
		let disappear = rac_signalForSelector("viewDidDisappear:").toSignalProducer()
			|> ignoreError
			|> map { _ in false }
		let viewIsActive = merge([appear, disappear])
		
		viewIsActive.start(next: {
			if $0 {
				c?.constraint.activate()
			}else{
				c?.constraint.deactivate()
			}
		})
	}
	
}