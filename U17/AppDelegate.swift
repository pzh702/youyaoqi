//
//  AppDelegate.swift
//  测试1
//
//  Created by PT iOS Mac on 2020/8/14.
//  Copyright © 2020 PT iOS Mac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	fileprivate func createMenuView() {
		let mainVC = MainViewController.init()
		let leftVC = LeftViewController.init()
//		let rightVC = RightViewController.init()

		let nVC = UINavigationController.init(rootViewController: mainVC)
		let slideVC = SlideMenuController.init(mainViewController: nVC, leftMenuViewController: leftVC)
		slideVC.automaticallyAdjustsScrollViewInsets = true
		slideVC.delegate = mainVC
//		slideVC.changeLeftViewWidth(200)

		SlideMenuOptions.contentViewScale = 1
		SlideMenuOptions.contentViewDrag = true
		SlideMenuOptions.contentViewOpacity = 0
		SlideMenuOptions.panFromBezel = false

		self.window?.backgroundColor = UIColor.white
		self.window?.rootViewController = slideVC
		self.window?.makeKeyAndVisible()

		let fpsLabel = U17FPSLabel.init(frame: CGRect.init(x: screenWidth-20-55, y: screenHeight-40, width: 55, height: 20))
		self.window?.addSubview(fpsLabel)
	}


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		self.createMenuView()
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
        // Saves changes in the application's managed object context before the application terminates.
    }


}

