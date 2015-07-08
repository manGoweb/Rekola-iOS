//
//  StoriesUI.swift
//  LandOfStories
//
//  Created by Dominik Vesely on 08/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation


extension UIImage {
    //tady bude enum z wwwdc
    
    
    //tady enum + funkce na toggle 
    
}

extension UIFont {
    
    class func mainRegular(size : CGFloat) -> UIFont! {
        return UIFont(name: "Main", size: size)!
    }
    
    class func mainLight(size : CGFloat) -> UIFont! {
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
    
    class func rekolaPinkColor() -> UIColor! {
        return UIColor(hex: 0xfd349c)
    }
    
    class func rekolaGrayTextFieldColor() -> UIColor! {
        return UIColor(hex: 0xececec)
    }
    
    class func rekolaGrayTextColor() -> UIColor! {
        return UIColor(hex: 0xb0b0b0)
    }
    
    class func staticGrayTextColor() -> UIColor! {
        return UIColor(hex: 0x757575)
    }
    
    class func rekolaGrayButtonColor() -> UIColor! {
        return UIColor(hex: 0xe1e1e1)
    }
    
    class func rekolaGrayLineColor() -> UIColor! {
        return UIColor(hex: 0xf1f1f1)
    }
    
    class func rekolaPinkTextFieldColor() -> UIColor! {
        return UIColor(hex: 0xff7abf)
    }
    
}

extension UIImage {
    enum ImageIdentifier: String {
        case logo = "logo"
        case mapPin = "mapPin"
        case logoutButton = "logoutButton"
        case locationButton = "locationButton"
        case directionButton = "directionButton"
        case bike = "bike"
        case aboutApp = "aboutApp"
        case signInBike = "signInBike"
        case ackee = "ackee"
        case borrowBike = "borrowBike"
    }
    
    convenience init!(imageIdentifier: ImageIdentifier) {
        self.init(named: imageIdentifier.rawValue)
    }
    
    enum ImagesForToggle: String {
        case Lock = "Lock"
        case Map = "Map"
        case Profile = "Profile"
    }
    
    /**
    Toggle on/off on UIButton image.
    
    :param: name enum of name of the images.
    
    :returns: tuple of images with on/off postfix.
    */
    class func toggleImage(name: ImagesForToggle) -> (on: UIImage!, off: UIImage!) {
        let imageOn = UIImage(named: name.rawValue + "On")
        let imageOff = UIImage(named: name.rawValue + "Off")
        return (imageOn!, imageOff!)
    }
}


enum L {
    static let contentInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    static let verticalSpacing = 10.0
    static let horizontalSpacing = 10.0
}

/**
 Theme class for creating standard UI elements for the app 

*/
class Theme {
    class func blueButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.blueColor()
        return button
    }
    
    class func pinkButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.rekolaPinkColor()
        button.layer.cornerRadius = 4
        return button
    }
    
    class func greenButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.rekolaGreenColor()
        return button
    }
    
    class func grayButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .rekolaGrayButtonColor()
        button.setTitleColor(.staticGrayTextColor(), forState: .Normal)
        button.layer.cornerRadius = 4
        return button
    }
    
    class func whiteButton() -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.rekolaGreenColor(), forState: .Normal)
        return button
    }
    
    class func textField() -> UITextField {
        let tf = UITextField()
        tf.backgroundColor = .rekolaGrayTextFieldColor()
        return tf
    }
    
    class func pinkTextField() -> UITextField {
        let tf = UITextField()
        tf.backgroundColor = .rekolaPinkTextFieldColor()
        return tf
    }
    
    class func titleLabel() -> UILabel {
        let l = UILabel()
        return l
    }
    
    class func subTitleLabel() -> UILabel {
        let l = UILabel()
        l.font = l.font.fontWithSize(13.0)
        l.textColor = .rekolaGrayTextColor()
        return l
    }
    
    class func lineView() -> UIView! {
        let line = UIView()
        line.backgroundColor = .rekolaGrayLineColor()
        return line
    }
    
    class func whiteLabel() -> UILabel {
        let l = UILabel()
        l.textColor = .whiteColor()
        return l
    }

}
    
