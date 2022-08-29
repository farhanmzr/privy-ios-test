//
//  AppDelegate.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 22/06/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let def = UserDefaults.standard
        let is_authenticated = def.bool(forKey: "is_authenticated") // return false if not found or stored value

        if is_authenticated {
            let window = UIWindow()
            window.rootViewController = UINavigationController(rootViewController: ProfileController())
            window.makeKeyAndVisible()
            self.window = window
        } else {
            let window = UIWindow()
            window.rootViewController = UINavigationController(rootViewController: LoginController())
            window.makeKeyAndVisible()
            self.window = window
        }
      return true
    }

    // MARK: - UISceneSession Lifecycle
    func application(
      _ application: UIApplication,
      configurationForConnecting connectingSceneSession: UISceneSession,
      options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }



}

