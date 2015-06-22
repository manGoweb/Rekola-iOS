//
//  StoriesUI.swift
//  LandOfStories
//
//  Created by Dominik Vesely on 08/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation


extension UIFont {
    
    class func mainRegular(size : CGFloat) -> UIFont {
        return UIFont(name: "Main", size: size)!
    }
    
    class func mainLight(size : CGFloat) -> UIFont {
        return UIFont(name: "Main-Light", size: size)!
    }
    
    class func printAllFonts() {
        for item in UIFont.familyNames() {
            let names = UIFont.fontNamesForFamilyName(item as! String)
            println("\(item): \(names)")
        }
    }
}


extension UIColor {
    
    class func mainColor() -> UIColor! {
        return UIColor(hex: 0x0000000)
    }
    
    class func rekolaGreenColor() -> UIColor! {
        return UIColor(hex: 0x7d8d38)
    }
    
}


/**
 Theme class for creating standard UI elements for the app 

*/
class Theme {
    
    class func blueButton() -> UIButton? {
        return nil
    }
    
    
}
    
