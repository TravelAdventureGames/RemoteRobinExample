//
//  AppDelegate.swift
//  RobinPrototype
//
//  Created by Martijn van Gogh on 29-06-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        UINavigationBar.appearance().tintColor = UIColor.white //maakt back en forward barbuttons wit
        UINavigationBar.appearance().barTintColor = UIColor(red: 0/255, green: 82/255, blue: 159/255, alpha: 1.0)///maakt de bar een kleur
        let shadow: NSShadow = NSShadow()
        shadow.shadowColor = UIColor.darkGray
        shadow.shadowOffset = CGSize(width: -1, height: -1)
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "SourceCodePro-Black", size: 30.0)!,//bepaalt fontsize
            NSForegroundColorAttributeName : UIColor.white//bepaald fontcolor
            //NSShadowAttributeName: shadow
        ]
        
        
        
        // maakt barbutton item bold en geeft lettertype
        let customFont = UIFont(name: "Kailasa-Bold", size: 16.0)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], for: UIControlState())
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    


}

