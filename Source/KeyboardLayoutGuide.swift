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




extension AppDelegate {
	
	private static var key : Selector { return Selector("keyboardHeight") }
	
	private struct AssociatedKeys {
		static var KeyboardHeight = "keyboardHeight"
	}
	
	var keyboardHeight : MutableProperty<CGFloat>! {
		if let storage = objc_getAssociatedObject(self, &AssociatedKeys.KeyboardHeight) as? MutableProperty<CGFloat> {
			return storage
		}else {
			logA("keyboardHeight was accessed before it was setup. Did you forget to call setupKeyboardLayoutGuide() in AppDelegate?")
			return nil
		}
	}
	
//	var keyboardLayoutGuide : UIView! {
//		if let g = objc_getAssociatedObject(self, &key) as? UIView {
//			return g
//		}else {
//			logA("Key window's keyboardLayoutGuide property was accessed before it was setup. Did you forget to call window?.setupKeyboardLayoutGuide() in AppDelegate?")
//			return nil
//		}
//	}
	
	func setupKeyboardLayoutGuide() {
		let storage = MutableProperty<CGFloat>(0)
		objc_setAssociatedObject(self, &AssociatedKeys.KeyboardHeight, storage, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
		
		//		let guide = UIView()
//		addSubview(guide)
//		var c : ConstraintDescriptionEditable!
//		guide.snp_makeConstraints { make in
//			make.height.equalTo(0)
//			make.left.right.equalTo(self)
//			c = make.bottom.equalTo(self).offset(0)
//		}
//		objc_setAssociatedObject(self, &key, guide, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC)) //held strongly, cant do weak ref easily
		
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
					return (height: rect.size.height, duration: duration, curve: curve)
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
			self.keyboardHeight.value = $0.height
			UIApplication.sharedApplication().keyWindow!.layoutIfNeeded() //TODO: dont layout whole window, let every vc layout its view. Currently, this would cause a deadlock on org.reactivecocoa.ReactiveCocoa.SignalProducer.buffer but should be fixed in future versions of rac
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

		let guide = UIView()
		view.addSubview(guide)
		var c : ConstraintDescriptionEditable!
		guide.snp_makeConstraints { make in
			make.left.right.equalTo(view)
			make.height.equalTo(0)
			c = make.bottom.equalTo(view).offset(0)
		}
		objc_setAssociatedObject(self, &AssociatedKeys.KeyboardLayoutGuide, guide, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC)) //held strongy, cant do weak ref easily
		if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
			delegate.keyboardHeight.producer
				|> start(next: { height in
				c.constraint.updateOffset(-height)
				view.setNeedsLayout()
			})
		}else{
			logA("Appdelegate is nil or not of class AppDelegate")
		}
		
		let appear = rac_signalForSelector("viewWillAppear:").toSignalProducer()
			|> ignoreError
			|> map { _ in true }
		let disappear = rac_signalForSelector("viewDidDisappear:").toSignalProducer()
			|> ignoreError
			|> map { _ in false }
		let viewIsActive = merge([appear, disappear])
		
		viewIsActive.start(next: {
			if $0 {
				c.constraint.activate()
			}else{
				c.constraint.deactivate()
			}
		})
	}
	
}