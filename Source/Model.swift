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
}



//MARK: Bike
public struct Bike {
    let id : Int
    let name : String
    let description : String
    let location : Address
    var issues : [String]
    let borrowed : Bool
    let operational : Bool
    let lastSeen : String?
    
}

extension Bike : Decodable  {
    static func create(id : Int) (name: String) (description: String) (location: Address) (issues: [String]) (borrowed : Bool) (operational : Bool) (lastSeen: String?) -> Bike {
        return Bike(id: id, name : name, description: description, location: location, issues : issues, borrowed: borrowed, operational: operational, lastSeen: lastSeen)
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
            <*> json <|? "lastSeen"

        //  <*> json <| "issues"
        
    }
}


