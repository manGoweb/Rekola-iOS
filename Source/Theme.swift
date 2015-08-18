//
//  StoriesUI.swift
//  LandOfStories
//
//  Created by Dominik Vesely on 08/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation

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


extension UIButton {

}

extension UIColor {
    
    class func mainColor() -> UIColor! {
        return UIColor(hex: 0x0000000)
    }
    
    class func rekolaBlackColor() -> UIColor! {
        return UIColor(hex: 0x404040)
    }
    
    class func rekolaSubtitleBlackColor() -> UIColor! {
        return UIColor(hex: 0x5c5c5c)
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
    
    class func rekolaGrayBorderColor() -> UIColor! {
        return UIColor(hex: 0xc2c2c2)
    }
    
    class func rekolaWarningYellowColor() -> UIColor! {
        return UIColor(hex: 0xffca82)
    }
    
    class func rekolaWarningRedColor() -> UIColor! {
        return UIColor(hex: 0xff4862)
    }
    
    class func rekolaBackgroundColor() -> UIColor! {
        return UIColor(hex: 0x666666)
    }
    
    class func rekolaLightPinkColor() -> UIColor! {
        return UIColor(hex: 0xfecfe3)
    }
}

extension UIImage {
    enum ImageIdentifier: String { //enumy maji zacinat velkym pismenem
        case logo = "logo"
        case mapPin = "mapPin"
        case logoutButton = "logoutButton"
        case locationButton = "locationButton"
        case directionButton = "directionButton"
        case bike = "bike"
        case ackeeAboutLogo = "ackeeAboutLogo"
        case aboutRest = "aboutRest"
        case signInBike = "signInBike"
        case ackee = "ackee"
        case borrowBike = "borrowBike"
        case code = "code"
        case biggerBorrowBike = "biggerBorrowBike"
        case yellowWarning = "yellowWarning"
        case redWarning = "redWarning"
        case clock = "clock"
        case calendar = "calendar"
        case trunk = "trunk"
        case frontlight = "frontlight"
        case backlight = "backlight"
        case basket = "basket"
        case buzzer = "buzzer"
        case mudguard = "mudguard"
        case textFieldButton = "textFieldButton"
        case cancelButton = "cancelButton"
        case detailLock = "detailLock"
        case MapPinPink = "mapPinPink"
        case MapPinGrey = "mapPinGrey"
        case MapPinGreen = "mapPinGreen"
        case BikeMapPinPink = "bikeMapPinPink"
        case DetailLockScroll = "detailLockScroll"
			case Placeholder = "placeholder"
    }
    
    convenience init!(imageIdentifier: ImageIdentifier) {
        self.init(named: imageIdentifier.rawValue)
    }
    
    enum ImagesForToggle: String {
        case Lock = "Lock"
        case Map = "Map"
        case Profile = "Profile"
        case BikeToggle = "bikeToggle"
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
	
	class func placeholderImageWithSize(size : CGSize) -> UIImage {
		let placeholder = UIImage(imageIdentifier: .Placeholder)
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		placeholder.drawInRect(CGRectMake(0, 0, size.width, size.height))
		let res = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return res
	}

}


enum L {
    static let contentInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    static let verticalSpacing = 15.0
    static let horizontalSpacing = 22.0
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
		button.setTitleColor(UIColor.grayColor(), forState: .Highlighted) //TODO: color
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 17)
        return button
    }
    
    class func greenButton() -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 17)
        button.backgroundColor = UIColor.rekolaGreenColor()
        return button
    }
    
    class func grayButton() -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 17)
        button.backgroundColor = .rekolaGrayButtonColor()
        button.setTitleColor(.staticGrayTextColor(), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        button.layer.cornerRadius = 4
        return button
    }
    
    class func whiteButton() -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 17)
        button.setTitleColor(UIColor.rekolaGreenColor(), forState: .Normal)
			button.setTitleColor(UIColor.rekolaGrayTextColor(), forState: .Disabled)
        return button
    }
    
    class func textField() -> UITextField {
        let tf = UITextField()
		let spacerView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)) //inset for textField
		tf.leftViewMode = .Always
		tf.leftView = spacerView1
        tf.backgroundColor = .rekolaGrayTextFieldColor()
        return tf
    }
    
    class func pinkTextField() -> UITextField {
        let tf = UITextField()
		let spacerView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)) //inset for textField
		tf.leftViewMode = .Always
		tf.leftView = spacerView1
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
    
    class func pinkLabel() -> UILabel {
        let l = UILabel()
        l.textColor = .rekolaPinkColor()
        l.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 16)
        return l
    }
    
    enum SFFont: String {
        case Regular = "SanFranciscoDisplay-Regular"
        case Medium = "SanFranciscoDisplay-Medium"
        case Bold = "SanFranciscoDisplay-Bold"
        case Italic = "SanFranciscoText-Italic"
    }
}
    
