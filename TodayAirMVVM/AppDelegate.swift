//
//  AppDelegate.swift
//  TodayAirMVVM
//
//  Created by 김동준 on 2020/10/19.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let splashView = SplashViewController()
        let reactor = SplashReactor()
        splashView.reactor = reactor
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = splashView
        
        return true
    }


}

