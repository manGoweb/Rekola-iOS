//
//  UIResponder+Errors.swift
//  Tipsy
//
//  Created by Petr Šíma on Jun/22/15.
//  Copyright © 2015 Petr Sima. All rights reserved.
//

import UIKit

public typealias ErrorHandlerCompletion = (res: ErrorHandlingResult, handledBy: ErrorHandlerType)->Void

public protocol ErrorHandlerType {

	func errorHandlingStep(error: NSError, severity: ErrorSeverity, sender: AnyObject?, userInfo: [NSObject: AnyObject]?, completion: ErrorHandlerCompletion?) -> (hasCompletion: Bool, stop: Bool) //return stop==false to pass error to nextResponder.
}

public class DefaultErrorHandler : NSObject, ErrorHandlerType, UIAlertViewDelegate {
	
	let isAdHoc = { return Environment.scheme == .AdHoc } //TODO: get from environment
	
	var pendingCompletions : [NSObject : ErrorHandlerCompletion] = [:]
	
	public func errorHandlingStep(error: NSError, severity: ErrorSeverity, sender: AnyObject?, userInfo: [NSObject: AnyObject]?, completion: ErrorHandlerCompletion?) -> (hasCompletion: Bool, stop: Bool) {
		println("Error: \(error), severity: \(severity), sender: \(sender), userInfo: \(userInfo)")
		
		var hasCompletion = false
		func presentError(_ messagePrefix: String = "") {
			let alert = UIAlertView(title: "Error", message: "\(messagePrefix) \(error)" , delegate: self, cancelButtonTitle: NSLocalizedString("OK",comment: ""))
			alert.show()
			if let completion = completion {
				self.pendingCompletions[alert] = completion
				hasCompletion = true
			}
		}
		
		switch severity {
		case .Debug:
			if isAdHoc() {
				presentError()
			}
		case .InformUser:
			presentError()
		case .UserAction:
			let message = "An error that requires user action was not handled, the app may misbehave."
			logE(message)
			if isAdHoc() {
				presentError(message)
			}
		}
		return (hasCompletion: hasCompletion, stop: false)
	}
	
	public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		if let completion = pendingCompletions[alertView] {
			completion(res: .AlertAction(buttonIndex: buttonIndex, actionIdentifier: "ok", userInfo: nil), handledBy: self)
			pendingCompletions.removeValueForKey(alertView)
		}
	}
}

extension UIResponder {
	
	public static var globalErrorHandlers : [ErrorHandlerType] = [DefaultErrorHandler()]
	
	public func handleError(error: NSError, severity: ErrorSeverity = .Debug, sender: AnyObject? = nil, userInfo: [NSObject: AnyObject]? = nil, completion: ErrorHandlerCompletion? = nil) -> [ErrorHandlerType] { //returns array of handler objects that have promised to call the completion block. Note: completion block may get called multiple times and may even get called before returning from this method.
		var haveCompletion : [ErrorHandlerType] = []
		var optResponder : UIResponder? = self
		while let responder = optResponder{
			var stop : Bool = false
			if let handler = responder as? ErrorHandlerType{
				let (hasCompl, s) = handler.errorHandlingStep(error, severity: severity, sender: sender, userInfo: userInfo, completion: completion)
				stop = s
				if hasCompl {
					haveCompletion.append(handler)
				}
			}
			optResponder = stop ? nil : responder.nextResponder()
		}
		for handler in UIResponder.globalErrorHandlers {
			let (hasCompl, stop) = handler.errorHandlingStep(error, severity: severity, sender: sender, userInfo: userInfo, completion: completion)
			if hasCompl {
				haveCompletion.append(handler)
			}
			if stop {
				break
			}
		}
	
		return haveCompletion
		
	}
}


public enum ErrorHandlingResult {
	case Success(userInfo: [NSObject:AnyObject]?)
	case Failure(newError: NSError?,userInfo: [NSObject:AnyObject]?)
	case AlertAction(buttonIndex: Int, actionIdentifier: String?, userInfo: [NSObject:AnyObject]?)
	case CantReproduce(userInfo: [NSObject:AnyObject]?) // When the handler tried to fix the error, it had already been fixed (probably by some other handler in the chain)
	case Custom(name: String, userInfo: [NSObject:AnyObject]?) //(custom result name, userInfo)
}

public enum ErrorSeverity {
	case Debug
	case InformUser
	case UserAction
	
	var description: String {
		switch self {
		case .Debug: return "Debug"
		case .InformUser: return "InformUser"
		case .UserAction: return "UserAction"
		}
	}
}

