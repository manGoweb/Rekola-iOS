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




extension UIWindow {
	
	private static var key : Selector { return Selector("keyboardHeight") }
	
	private struct AssociatedKeys {
		static var KeyboardLayoutGuide = "keyboardLayoutGuide"
	}
	
	var keyboardLayoutGuide : UIView! {
		if let storage = objc_getAssociatedObject(self, &AssociatedKeys.KeyboardLayoutGuide) as? UIView {
			return storage
		}else {
			logA("keyboardLayoutGuide was accessed before it was setup. Did you forget to call setupKeyboardLayoutGuide() in AppDelegate?")
			return nil
		}
	}
	
	func setupKeyboardLayoutGuide() {

		let guide = UIView()
		addSubview(guide)
		var c : ConstraintDescriptionEditable!
		guide.snp_makeConstraints { make in
			make.height.equalTo(0)
			make.left.right.equalTo(self)
			c = make.bottom.equalTo(self).offset(0)
		}
		objc_setAssociatedObject(self, &AssociatedKeys.KeyboardLayoutGuide, guide, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC)) //held strongly, cant do weak ref easily
		
		let show = NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillShowNotification, object: nil).toSignalProducer()
			|> ignoreError
			|> map { (note : AnyObject?) -> (height: CGFloat, duration: Double, curve: UIViewAnimationCurve)? in
				if let userInfo = (note as? NSNotification)?.userInfo {
					let rect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
					let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
					let curve = UIViewAnimationCurve(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue)!
					return (height: rect.size.height, duration: duration, curve: curve)
				}
				return nil
			}
			|> ignoreNil
		
		let hide = NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillHideNotification, object: nil).toSignalProducer()
			|> ignoreError
			|> map { (note : AnyObject?) -> (height: CGFloat, duration: Double, curve: UIViewAnimationCurve)? in
				if let userInfo = (note as? NSNotification)?.userInfo {
					let rect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
					let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
										let curve = UIViewAnimationCurve(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue)!
					return (height: self.bounds.size.height - rect.origin.y, duration: duration, curve: curve)
				}
				return nil
			}
			|> ignoreNil
//		let changeFrame = NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardDidChangeFrameNotification, object: nil).toSignalProducer()
//		|> ignoreError
//		|> map { (note : AnyObject?) -> CGFloat? in
//			if let rectValue = (note as? NSNotification)?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
//				return rectValue.CGRectValue().height
//			}
//			return nil
//			}
//			|> ignoreNil
	
		
		let height = merge([show, hide/*, changeFrame*/])
		height.start(next: {
			UIView.beginAnimations(nil, context: nil)
			UIView.setAnimationDuration($0.duration)
			UIView.setAnimationCurve($0.curve)
			c.constraint.updateOffset(-$0.height)
			self.layoutIfNeeded()
			UIView.commitAnimations()
			})
	}
	
}

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
		if self.isKindOfClass(NSClassFromString("UIStatusBarViewController")) { //Private class initialized before appdelegate lifecycle methods get called. TODO: this is fragile code that may break in the future, find another way to make sure keyboardLayoutGuide is initialized in time
			return
		}
		let guide = UIView()
		view.addSubview(guide)
		var c : ConstraintDescriptionEditable?

		objc_setAssociatedObject(self, &AssociatedKeys.KeyboardLayoutGuide, guide, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC)) //held strongy, cant do weak ref easily
		
		
		let didMoveToWindow = view.rac_signalForSelector("didMoveToWindow").toSignalProducer()
		didMoveToWindow.start(next: { [weak self] _ in
			if let windowGuide = view.window?.keyboardLayoutGuide {
				self?.keyboardLayoutGuide.snp_remakeConstraints { make in
					c = make.edges.equalTo(windowGuide)
				}
			}else{
				self?.keyboardLayoutGuide.snp_remakeConstraints { make in }
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