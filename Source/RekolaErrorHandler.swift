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

        let response: AnyObject? = error.userInfo?[APIErrorKeys.response]
        let statusCode = response?.statusCode
        println("==============")
        println(response?.statusCode)
        println("==============")
        
        if let responseData = error.userInfo?[APIErrorKeys.responseData] as? NSData {
            let alert = UIAlertView(title: NSLocalizedString("ERROR", comment: ""), message: "", delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: ""))
            if let json = NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments, error: nil) as? [String : AnyObject] {
                if let msg = json["message"] as? String {
                    if let statusCode = response?.statusCode {
                        if statusCode == 401 {
                            NSUserDefaults.standardUserDefaults().removeObjectForKey("apiKey")
            
                            let signIn = SignInViewController()
                            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
                            delegate.window?.rootViewController = signIn
                            delegate.window!.makeKeyAndVisible()
                        }
                    }
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