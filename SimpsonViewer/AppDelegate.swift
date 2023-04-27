//
//  AppDelegate.swift
//  AnywhereDemo
//
//  Created by Matthew Kaulfers on 4/26/23.

// Disclaimer and Notice of Limited Use:
//
// Please be advised that the code contained in this project (hereinafter referred to as the "Code")
// is provided solely for review purposes. The Code is the exclusive property of Matthew Kaulfers
// (hereinafter referred to as the "Author") and remains subject to all applicable intellectual
// property rights, including but not limited to copyright and trade secret protections.
//
// By accessing or reviewing the Code, you expressly acknowledge and agree that you shall not,
// directly or indirectly, copy, modify, distribute, reproduce, create derivative works, reverse
// engineer, decompile, or otherwise attempt to discover, exploit, or use the Code or any portion
// thereof for any purpose other than the express purpose of review, without the prior written
// consent of the Author.
//
// In the event of any unauthorized use, copying, or distribution of the Code or any portion
// thereof, you shall be held legally responsible for any and all damages, losses, or liabilities
// incurred by the Author, including but not limited to legal fees and costs, as a result of such
// unauthorized actions.
//
// Your access to and review of the Code shall not be construed as a grant of any license or other
// rights to the Code, either expressly or by implication, estoppel, or otherwise, except as
// expressly set forth in this Disclaimer and Notice of Limited Use.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

