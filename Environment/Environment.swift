//
//  Environment.swift
//  Rekola
//
//  Created by Petr Šíma on Jun/24/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation

enum Environment {
	private static let plist : [String: AnyObject] = NSDictionary(contentsOfFile:(NSBundle.mainBundle().pathForResource("environment", ofType:"plist")!))! as! [String : AnyObject]
	
	enum Scheme : String {
		case AppStore = "AppStore"
		case AdHoc = "AdHoc"
		case Development = "Development"
		case Undefined = "Undefined"
		var description : String { return rawValue }
	}
	static var scheme : Scheme { return Scheme(rawValue: plist["scheme"]! as! String) ?? .Undefined }
	static var appName : String { return plist["appName"]! as! String }
	static var baseURL : String { return plist["baseURL"]! as! String }
	
}