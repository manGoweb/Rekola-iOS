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
    
    static let baseURL = ACKEnvironment.sharedEnvironment().baseURL
    
    
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

class RekolaAPI {
    
    
    
    private class func callAndRefreshTokenIfNecessary<T>(signal :SignalProducer<T,NSError> )
        -> SignalProducer <T,NSError> {
            
            return signal
                |> catch { (error : NSError)  in
                    //   if let response = error.userInfo[""] as? NSHTTPURLResponse {
                    //   if let response =  {
                    //       if response.statusCode == 401 {
                    //           return self.auth() |> then(signal)
                    //       }
                    
                    //   }
                    return SignalProducer(error: error)
            }
            
    }
    
    
    
    
    private class func call<T>(route: Router, action: (AnyObject -> (SignalProducer<T,NSError>))) -> SignalProducer<T,NSError> {
        
        var signal = SignalProducer<T,NSError> { sink, disposable in
            
            Alamofire.request(route).response { (request, response, data, error) in
                
                if let json = data as? NSData {
                    let jsonString: AnyObject? = NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions(0), error: nil)
                    var str =  action(jsonString!)
                    str |> start(sink)
                }
                
            }
            return
        }
        
        return signal
        
    }
    
    
    
    
    
    class func login(username: String, password: String) -> SignalProducer<String,NSError>  {
        return  call(.Login(dictionary:["password" : password, "username" : username])) { data in
            //namapuju resp zgrootuju
            return rac_decode(data)
                //side-effect jednotlivych requestů
                |> map({ (info: LoginInfo)  in
                    return info.apiKey
                })
                |> on(next: {
                    //provedu save do databaze napriklad
                    NSUserDefaults.standardUserDefaults().setValue($0, forKey: "apiKey")
                })
                //chytne error a specific request error codes handling
                // side effect po tom co skoncim
                |> on(completed: { println("Hotovo") })
            // namapuju LoginInfo k tomu ze vratim pouze string
            
        }
    }
    
    class func bikes(latitude: Double, longitude: Double) -> SignalProducer<[Bike],NSError> {
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







