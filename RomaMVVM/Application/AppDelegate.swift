//
//  AppDelegate.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 24.10.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        customizeNavBar()
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after
        // application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func customizeNavBar() {
        let newNavBarAppearance = customNavBarAppearance()
              
          let appearance = UINavigationBar.appearance()
          appearance.scrollEdgeAppearance = newNavBarAppearance
          appearance.compactAppearance = newNavBarAppearance
          appearance.standardAppearance = newNavBarAppearance
          if #available(iOS 15.0, *) {
              appearance.compactScrollEdgeAppearance = newNavBarAppearance
          }
    }
    
    private func customNavBarAppearance() -> UINavigationBarAppearance {
        let customNavBarAppearance = UINavigationBarAppearance()
        
        customNavBarAppearance.configureWithOpaqueBackground()

        customNavBarAppearance.shadowColor = .red
        customNavBarAppearance.backgroundColor = .green
        
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.black]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.black]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance
        
        return customNavBarAppearance
    }
}
