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
            let alert = UIAlertView(title: NSLocalizedString("ERROR", comment: ""), message: "", delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
            if let json = NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments, error: nil) as? [String : AnyObject] {
                if let msg = json["message"] as? String {
                    println("MESSAGE: \(msg)")
                    alert.message = msg
                    alert.show()
                } else {
                    alert.message = NSLocalizedString("ERROR_coomunication", comment: "")
                    alert.show()
                }
            } else {
                alert.message = NSLocalizedString("ERROR_coomunication", comment: "")
                alert.show()
            }
            return (false, true)
		}
		
		return (false, false)
	}
}