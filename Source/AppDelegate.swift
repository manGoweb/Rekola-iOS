//
//  AppDelegate.swift
//  SwiftPokus
//
//  Created by Dominik Vesely on 07/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import ReactiveCocoa




@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate , BITHockeyManagerDelegate {
    var window: UIWindow?
	
	
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		

		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window?.setupKeyboardLayoutGuide()
		
        #if !DEBUG
        //BITHockeyManager.sharedHockeyManager().configureWithIdentifier("", delegate: self)
       // BITHockeyManager.sharedHockeyManager().startManager()
      //  BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()
      //  BITHockeyManager.sharedHockeyManager().crashManager.crashManagerStatus = BITCrashManagerStatus.AutoSend
        #endif
        
     //   Flurry.startSession("")
        
       
        
        let producer = API.login("josef.gattermayer@ackee.cz", password: "AckeeTest") |> then(API.bikes(50, longitude: 14))
        producer.start(error: { println($0) }, next: { [weak self] (bikes : [Bike]) in
            })
                
        let vc = UINavigationController(rootViewController: LockViewController())
        let vc2 = UINavigationController(rootViewController: MapViewController())
        let vc3 = UINavigationController(rootViewController: ProfileViewController())
        
        let item = TabItem(controller: vc, images: UIImage.toggleImage(UIImage.ImagesForToggle.Lock))
        let item2 = TabItem(controller: vc2, images: UIImage.toggleImage(UIImage.ImagesForToggle.Map))
        let item3 = TabItem(controller: vc3, images: UIImage.toggleImage(UIImage.ImagesForToggle.Profile))
        
        let tabbar = ACKTabBarController(items: [item,item2,item3])
        let signIn = SignInViewController()
        window?.rootViewController = signIn
        window?.makeKeyAndVisible()
        window?.tintColor = UIColor.whiteColor()
        
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        
//        UINavigationBar.appearance().barTintColor = 
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
    func crashManagerWillSendCrashReport(crashManager: BITCrashManager!) {
        
    }
    
    func crashManagerWillSendCrashReportsAlways(crashManager: BITCrashManager!) {
        
    }
    
    func crashManagerDidFinishSendingCrashReport(crashManager: BITCrashManager!) {
        
    }
    
    func crashManagerWillCancelSendingCrashReport(crashManager: BITCrashManager!) {
        
    }

}

