//
//  Model.swift
//  Rekola
//
//  Created by Dominik Vesely on 11/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import Argo
import Runes
import CoreLocation


////MARK: logininfo

public struct LoginInfo {
    let apiKey : String
    let terms : Bool
}

extension LoginInfo : Decodable {
    static func create(apiKey: String)(terms: Bool) -> LoginInfo {
        return LoginInfo(apiKey: apiKey, terms: terms)
    }
    
    public static func decode(j: JSON) -> Decoded<LoginInfo> {
        return LoginInfo.create
            <^> j <| "apiKey"
            <*> j <| "terms"
    }
}

//MARK: Address
public struct Address {
    let lat : Double
    let lng : Double
    let address : String
    let distance : String
    let note : String?
}

extension Address : Decodable {
    static func create(lat: Double)( lng: Double)( address: String)( distance: String) (note : String?) -> Address {
        return Address(lat: lat, lng: lng, address: address, distance: distance, note: note)
    }
    public static func decode(json: JSON) -> Decoded<Address> {
        return Address.create
            <^> json <| "lat"
            <*> json <| "lng"
            <*> json <| "address"
            <*> json <| "distance"
            <*> json <|? "note"

    }
    
//    only for testing!
    static func myDumbAddress() -> Address {
        let lat = 50.0825967
        let lng = 14.4260456
        let address = "Václavské náměstí 19, Praha 1"
        let distance = "120 m"
        let note = "u druhého patníku vlevo"
        
        return Address(lat: lat, lng: lng, address: address, distance: distance, note: note)
    }
}



//MARK: Bike
public struct Bike {
    let id : Int
    let name : String
    let type: String
    let description : String
    let location : Address
    var issues : [Int]
    let borrowed : Bool
    let operational : Bool
    let returnedAt : NSDate?
    let lastSeen: NSDate
    
//    icons
    let iconUrl : String
	let lockCode : String?
	let imageURLString : String
}

extension Bike {
	var imageURL : NSURL {
		return NSURL(string: imageURLString)!
	}
}

extension Bike : Decodable  {
	static var dateFormatter : NSDateFormatter = {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		return dateFormatter
		}()
    
    static var timeFormatter : NSDateFormatter = {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "dd.MM. HH:mm"
        return timeFormatter
    }()
	
//	static func parseDate(string: String?) -> Decoded<NSDate?> {
//		return pure(flatMap(string) {self.dateFormatter.dateFromString($0 ?? "")})
//	}
	
    static func create(id : Int) (_ name: String) (_ type: String) (_ description: String) (_ location: Address) (_ issues: [Int]) (_ borrowed : Bool) (_ operational : Bool) (_ returnedAt: String?) (_ lastSeen: String) (_ iconUrl: String) (_ lockCode : String?)(_ imageUrlString : String) -> Bike {
		let returnedDate = dateFormatter.dateFromString(returnedAt ?? "")
        let returnedTime = timeFormatter.dateFromString(lastSeen)
        return Bike(id: id, name : name, type: type, description: description, location: location, issues : issues, borrowed: borrowed, operational: operational, returnedAt: returnedDate, lastSeen: returnedTime!, iconUrl: iconUrl, lockCode: lockCode, imageURLString: imageUrlString)
    }
    
    public static func decode(json: JSON) -> Decoded<Bike> {
        let partOfBike = Bike.create
            <^> json <| "id"
            <*> json <| "name"
            <*> json <| "bikeType"
            <*> json <| "description"
            <*> json <| "location"
            <*> json <|| "issues"
            <*> json <| "borrowed"
            <*> json <| "operational"
//            <*> json <|? ["location","returnedAt"] >>- parseDate //wont compile
        return partOfBike
            <*> json <|? ["location","returnedAt"]
            <*> json <| "lastSeen"
            <*> json <| "iconUrl"
            <*> json <|? "lockCode"
            <*> json <| "imageUrl"
        //  <*> json <| "issues"

        
    }
    
//    static func myBike()->Bike {
//        let id = 123
//        let name = "Kolo kolo mlýnské"
//        let description = "horské kolo s gumama jako salámy"
//        let issues = ["5","8"]
//        let borrowed = false
//        let lastSeen = "30.10. 11:56"
//        let operational = true
//        let adrress = Address.myDumbAddress()
//        let iconUrl = "https://www.rekola.cz/api/images/1.svg"
//        
//        return Bike(id: id, name: name, description: description, location: adrress, issues: issues, borrowed: borrowed, operational: operational, lastSeen: lastSeen, iconUrl: iconUrl)
//    }
	
}

//TODO: report problem

struct BikeReportProblem {
    let type : Int
    let title : String
    let description : String
    let disabling : Bool
    let location : CLLocationCoordinate2D
    
    var jsonRepresentation : [String : AnyObject] {
        var locationDict : [String : AnyObject] = ["lat" : location.latitude, "lng" : location.longitude]
        var dict : [String : AnyObject ] = ["location" : locationDict,"type": type, "title": title, "description": description, "disabling" : disabling]
        return dict
    }
}

struct BikeReturnInfo {
	let lat : Double
	let lon : Double
	let note : String?
	let sensorLat : Double?
	let sensorLon : Double?
	let sensorAcc : Double?
	
	var jsonRepresentation : [String : AnyObject] {
		var d : [String : AnyObject] = [ "lat" : lat, "lng" : lon ]
		if let note = note {
			d["note"] = note
		}
		if let sensorLat = sensorLat {
			d["sensorLat"] = sensorLat
		}
		if let sensorLon = sensorLon {
			d["sensorLng"] = sensorLon
		}
		if let sensorAcc = sensorAcc {
			d["sensorAccuracy"] = sensorAcc
		}
		return d
	}
}

extension CLLocationCoordinate2D : Decodable {
    static func create(latitude: Double) (longitude: Double) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public static func decode(json: JSON) -> Decoded<CLLocationCoordinate2D> {
        return CLLocationCoordinate2D.create
            <^> json <| "latitude"
            <*> json <| "longitude"
    }
}

struct Update {
    let author: String
    let description: String
    let issuedAt: NSDate
}

extension Update : Decodable {
    static var dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
        }()
    
    static func create(author: String) ( description: String) (issuedAt: String) -> Update {
        let returnedDate = dateFormatter.dateFromString(issuedAt)
        return Update(author: author, description: description, issuedAt: returnedDate!)
    }

    
    internal static func decode(json: JSON) -> Decoded<Update> {
        return Update.create
            <^> json <| "author"
            <*> json <| "description"
            <*> json <| "issuedAt"
    }
    
}

public struct BikeIssue {
    let id: Int
    let title: String
    let status: String
    let updates: [Update]
}

extension BikeIssue : Decodable {
    static func create(id: Int) ( title: String) ( status: String) ( updates: [Update]) -> BikeIssue {
        return BikeIssue(id: id, title: title, status: status, updates: updates)
    }
    
    public static func decode(json: JSON) -> Decoded<BikeIssue> {
        return BikeIssue.create
            <^> json <| "id"
            <*> json <| "title"
            <*> json <| "status"
            <*> json <|| "updates"
    }
}

public struct MyAccount {
    let name: String
    let registrationDate: NSDate
    let membershipEnd: NSDate
    let email: String
    let phone: String
    let address: String
}

extension MyAccount : Decodable {
    static var dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
        }()
    
    static func create(name: String) ( registrationDate: String) (membershipEnd: String) (email: String) (phone: String) (address: String) -> MyAccount {
        let registration = dateFormatter.dateFromString(registrationDate)
        let membership = dateFormatter.dateFromString(membershipEnd)
        
        return MyAccount(name: name, registrationDate: registration!, membershipEnd: membership!, email: email, phone: phone, address: address)
    }
    
    public static func decode(json: JSON) -> Decoded<MyAccount> {
        return MyAccount.create
            <^> json <| "name"
            <*> json <| "registrationDate"
            <*> json <| "membershipEnd"
            <*> json <| "email"
            <*> json <| "phone"
            <*> json <| "address"
    }
}

public struct DefaultProblem {
    let id: Int
    let title: String
}

extension DefaultProblem : Decodable {
    static func create(id: Int) ( title: String) -> DefaultProblem {
        return DefaultProblem(id: id, title: title)
    }
    
    public static func decode(json: JSON) -> Decoded<DefaultProblem> {
        return DefaultProblem.create
            <^> json <| "id"
            <*> json <| "title"
    }
}

public struct Issues {
    let issues: [DefaultProblem]
}

extension Issues : Decodable {
    static func create(issues: [DefaultProblem]) -> Issues {
        return Issues(issues: issues)
    }
    
    public static func decode(json: JSON) -> Decoded<Issues> {
        return Issues.create
            <^> json <|| "issues"
    }
}

public struct AddIssue {
    let id : Int
    let title : String
}
