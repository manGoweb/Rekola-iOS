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
    let description : String
    let location : Address
    var issues : [Int]
    let borrowed : Bool
    let operational : Bool
    let returnedAt : NSDate?
    
//    icons
    let iconUrl : String
	let lockCode : String
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
	
//	static func parseDate(string: String?) -> Decoded<NSDate?> {
//		return pure(flatMap(string) {self.dateFormatter.dateFromString($0 ?? "")})
//	}
	
	static func create(id : Int) (name: String) (description: String) (location: Address) (issues: [Int]) (borrowed : Bool) (operational : Bool) (returnedAt: String?) (iconUrl: String) (lockCode : String)(imageUrlString : String) -> Bike {
		let returnedDate = dateFormatter.dateFromString(returnedAt ?? "")
		return Bike(id: id, name : name, description: description, location: location, issues : issues, borrowed: borrowed, operational: operational, returnedAt: returnedDate, iconUrl: iconUrl, lockCode: lockCode, imageURLString: imageUrlString)
    }
    
    public static func decode(json: JSON) -> Decoded<Bike> {
        return Bike.create
            <^> json <| "id"
            <*> json <| "name"
            <*> json <| "description"
            <*> json <| "location"
            <*> json <|| "issues"
            <*> json <| "borrowed"
            <*> json <| "operational"
//            <*> json <|? ["location","returnedAt"] >>- parseDate //wont compile
			<*> json <|? ["location","returnedAt"]
            <*> json <| "iconUrl"
				<*> json <| "lockCode"
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

