//
//  RekolaErrorHandler.swift
//  Rekola
//
//  Created by Petr Šíma on Jul/30/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation

class RekolaErrorHandler : ErrorHandlerType {
	func errorHandlingStep(error: NSError, severity: ErrorSeverity, sender: AnyObject?, userInfo: [NSObject : AnyObject]?, completion: ErrorHandlerCompletion?) -> (hasCompletion: Bool, stop: Bool) {
		
		if let responseData = error.userInfo?[APIErrorKeys.responseData] as? NSData {
			let msg = NSString(data: responseData, encoding: NSUTF8StringEncoding) as String?
				let a = UIAlertView(title: NSLocalizedString("ERROR", comment: ""), message: msg, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
			return (false, true)
		}
		
		return (false, false)
	}
}