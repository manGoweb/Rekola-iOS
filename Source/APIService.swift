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

//TODO: endpointy co pouziva android, implementovat
//	@POST("/accounts/mine/login")
//	public void login(@Body Credentials body, Callback<Login> callback);
//	
//	@PUT("/password-recovery")
//	public void recoverPassword(@Body RecoverPassword body, Callback<Object> callback);
//	
//	@GET("/accounts/mine/logout")
//	public void logout(@Header(Constants.HEADER_KEY_TOKEN) String token, Callback<Object> callback);
//	
//	@GET("/bikes/all")
//	public void getBikes(@Header(Constants.HEADER_KEY_TOKEN) String token, @Query("lat") String lat, @Query("lng") String lng, Callback<List<Bike>> callback);
//	
//	@GET("/bikes/mine")
//	public void getBorrowedBike(@Header(Constants.HEADER_KEY_TOKEN) String token, Callback<BorrowedBike> callback);
//	
//	@GET("/bikes/lock-code")
//	public void borrowBike(@Header(Constants.HEADER_KEY_TOKEN) String token, @Query("bikeCode") int bikeCode, @Query("lat") String lat, @Query("lng") String lng, Callback<LockCode> callback);
//	
//	@PUT("/bikes/{id}/return")
//	public void returnBike(@Header(Constants.HEADER_KEY_TOKEN) String token, @Path("id") int bikeCode, @Body ReturningBike returningBike, Callback<ReturnedBike> callback);
//	
//	@GET("/bikes/{bikeId}/issues?onlyOpen=1")
//	public void getBikeIssues(@Header(Constants.HEADER_KEY_TOKEN) String token, @Path("bikeId") int bikeId, Callback<List<Issue>> callback);
//	
//	@GET("/location/pois")
//	public void getPois(@Header(Constants.HEADER_KEY_TOKEN) String token, @Query("lat") String lat, @Query("lng") String lng, Callback<List<Poi>> callback);
//	
//	@GET("/accounts/mine")
//	public void getAccount(@Header(Constants.HEADER_KEY_TOKEN) String token, Callback<Account> callback);
//	
//	@GET("/boundaries/")
//	public void getBoundaries(@Header(Constants.HEADER_KEY_TOKEN) String token, Callback<Boundaries> callback);
//	
//	@GET("/default-values/")
//	public void getDefaultValues(@Header(Constants.HEADER_KEY_TOKEN) String token, Callback<DefaultValues> callback);
//	
//	@POST("/bikes/{id}/issues")
//	public void reportIssue(@Header(Constants.HEADER_KEY_TOKEN) String token, @Path("id") int  bikeId,
//	@Body IssueReport body, Callback<Object> callback);
	
    case Login(dictionary: [String:AnyObject])
	case PasswordRecovery(email: String)
    case Bikes(dictionary: [String:Double])
    case MyBike
	case BorrowBike(code: String, lat: String, lon: String)
	case ReturnBike(id: Int, info : BikeReturnInfo)
	
    var method : Alamofire.Method {
        switch self {
        case .Login:
            return .POST
		case .PasswordRecovery:
			return .PUT
        case .Bikes:
            return .GET
		case .MyBike:
			return .GET
		case .BorrowBike:
			return .GET //fuj ble
		case .ReturnBike:
			return .PUT
		}
    }
    
    var path : String {
        switch self {
        case .Login:
            return "/accounts/mine/login"
		case .PasswordRecovery:
			return "/password-recovery"
        case .Bikes:
            return "/bikes/all"
		case .MyBike:
			return "/bikes/mine"
		case .BorrowBike:
			return "/bikes/lock-code"
		case .ReturnBike(let id, _):
			return "/bikes/\(id)/return"
        }
    }
    
    var URLRequest : NSURLRequest {
        let URL = NSURL(string: Router.baseURL)!
        
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        if let key = NSUserDefaults.standardUserDefaults().stringForKey("apiKey") {
            mutableURLRequest.setValue(key, forHTTPHeaderField: "X-Api-Key")
        }
			mutableURLRequest.setValue("1.0.0", forHTTPHeaderField: "X-Api-Version")
		
		//Client-Os nechci at si to vezmou z User-Agent
        
        switch self {
            
        case .Login(let params):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params).0
		case .PasswordRecovery(email: let email):
			return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["email" : email]).0
		case .BorrowBike(code: let code, lat: let lat, lon: let lon):
			return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: ["bikeCode" : code, "lat" : lat, "lng" : lon]).0
		case .ReturnBike(_, let info):
			return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["location" : info.jsonRepresentation]).0
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
                if let json = data {
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
		return  call(.Login(dictionary:["password" : password, "username" : username]), authHandler: nil) { data in
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
	
	func passwordRecovery(#email: String) -> SignalProducer<(), NSError> {
		return call(.PasswordRecovery(email: email), authHandler: nil) { data in
			return SignalProducer.empty
		}
	}
	
	func myBike() -> SignalProducer<Bike?, NSError> {
		return call(.MyBike) { data in
			logD(data)
			let parse : SignalProducer<Bike, NSError> = rac_decode(data)
			return parse |> map { $0 as Bike? }
			}
			|> catch { error in
				let statusCode = (error.userInfo?[APIErrorKeys.response] as? NSHTTPURLResponse)?.statusCode
				switch statusCode {
				case let .Some(404):
					return SignalProducer(value: nil)
				default:
					return SignalProducer(error: error)
				}
		}
	}
	
	func borrowBike(#code : String, location:  CLLocation) -> SignalProducer<Bike, NSError> {
		let lat = "\(location.coordinate.latitude)"
		let lon = "\(location.coordinate.longitude)"
		return call(.BorrowBike(code: code, lat: lat, lon: lon)) { data in
			let dataDict = data as! [String : AnyObject]
			var bike = dataDict["bike"] as! [String : AnyObject]
			bike["lockCode"] = data["lockCode"]!
			let parse : SignalProducer<Bike, NSError> = rac_decode(bike)
			return parse
		}
	}
	
	func bikes(#latitude: Double, longitude: Double) -> SignalProducer<[Bike],NSError> {
        return call(Router.Bikes(dictionary: ["lat": latitude, "lng" : longitude])) { data in
            let signal : SignalProducer<Bike,NSError> = rac_decodeByOne(data)
            return signal
                |> on(next : { item in
                    println(item)
                })
                |> collect
        }
    }
	
	func returnBike(#id : Int , info : BikeReturnInfo) -> SignalProducer<AnyObject?, NSError> {
		return call(Router.ReturnBike(id: id, info: info)) { data in
			logD(data)
			return SignalProducer.empty
		}
	}
	
    
}







