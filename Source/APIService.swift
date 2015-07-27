//
//  APIService.swift
//  Rekola
//
//  Created by Dominik Vesely on 10/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa
import Argo


enum Router : URLRequestConvertible {
    
    static let baseURL = Environment.baseURL
    
    
    case Login(dictionary: [String:AnyObject])
    case Bikes(dictionary: [String:Double])
    
    
    var method : Alamofire.Method {
        switch self {
        case .Login:
            return .POST
            
        case .Bikes:
            return .GET
        }
    }
    
    var path : String {
        switch self {
        case .Login:
            return "/accounts/mine/login"
        case .Bikes:
            return "/bikes/all"
        }
    }
    
    var URLRequest : NSURLRequest {
        let URL = NSURL(string: Router.baseURL)!
        
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        if let key = NSUserDefaults.standardUserDefaults().stringForKey("apiKey") {
            mutableURLRequest.setValue(key, forHTTPHeaderField: "X-Api-Key")
        }
        
        switch self {
            
        case .Login(let params):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params).0
            
            
        default:
            return mutableURLRequest
        }
        
    }
    
    
}

let API = RekolaAPI._instance

struct APIErrorKeys {
	static let response = "FailingRequestResponse"
	static let responseData = "FailingRequestResponseData"
}

class RekolaAPI {

	static let _instance = RekolaAPI()
	private init() {}

	typealias AuthHandler = (error: NSError) -> SignalProducer<AnyObject, NSError>?
	
	private static func authHandler(error: NSError) -> SignalProducer<AnyObject, NSError>? { //instance method cant be used as default parameter of call, this solution is ok as long as RekolaAPI is a singleton
		if let response = error.userInfo?[APIErrorKeys.response] as? NSHTTPURLResponse {
			switch response.statusCode {
				case 401:
					return _instance.login(username: "putCurrentUsernameHere", password: "putCurrentPasswordHere") |> flatMap(.Merge) { _ in SignalProducer.empty } //login doesnt have to send any values. If it sends a value, the value is ignored, the signal completes and is unsubscribed from
				default:
					return nil
			}
		}
		return nil
	}
	
	private func call<T>(route: Router, var authHandler: AuthHandler? = RekolaAPI.authHandler, action: (AnyObject -> (SignalProducer<T,NSError>))) -> SignalProducer<T,NSError> {
        var signal = SignalProducer<T,NSError> { sink, disposable in
            
            Alamofire.request(route)
					.validate()
					.response { (request, response, data, error) in
					if let error = error {
						var newInfo = NSMutableDictionary(object: response ?? NSNull(), forKey: APIErrorKeys.response)
						newInfo.addEntriesFromDictionary([APIErrorKeys.responseData : data ?? NSNull()])
						if let userInfo = error.userInfo {
							newInfo.addEntriesFromDictionary(userInfo)
						}
						let newError = NSError(domain: error.domain, code: error.code, userInfo: newInfo as [NSObject : AnyObject])
						sendError(sink, newError)
						return
					}
                if let json = data as? NSData {
						var jsonError : NSError?
						let jsonString: AnyObject? = NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions(0), error: &jsonError)
						if let jsonError = jsonError {
							sendError(sink, jsonError)
							return
						}
						logD(jsonString)
						let str =  action(jsonString!)
						str |> start(sink)
						return
					}
					sendError(sink, NSError(domain: "", code: 0, userInfo: nil))//shouldnt get here
            }
            return
        }
		
		if let handler = authHandler {
			return signal |> catch { error in
				if let handlingCall = handler(error: error) {
					return handlingCall |> then(signal)
				}else{
					return SignalProducer(error: error)
				}
			}
		}else{
			return signal
		}
	}

    
    
	func login(#username: String, password: String) -> SignalProducer<String,NSError>  {
        return  call(.Login(dictionary:["password" : password, "username" : username])) { data in
            //namapuju resp zgrootuju
            return rac_decode(data)
                //side-effect jednotlivych requestů
                |> map({ (info: LoginInfo)  in
                    return info.apiKey
                })
                |> on(next: {
                    //provedu save do databaze napriklad
                    println($0)
                    NSUserDefaults.standardUserDefaults().setValue($0, forKey: "apiKey")
                })
                //chytne error a specific request error codes handling
                // side effect po tom co skoncim
                |> on(completed: { println("Hotovo") })
            // namapuju LoginInfo k tomu ze vratim pouze string
            
        }
    }
    
    func bikes(latitude: Double, longitude: Double) -> SignalProducer<[Bike],NSError> {
        return call(Router.Bikes(dictionary: ["lat": latitude, "lng" : longitude])) { data in
            let signal : SignalProducer<Bike,NSError> = rac_decodeByOne(data)
            return signal
                |> on(next : { item in
                    println(item)
                })
                |> collect
        }
    }
    
}







