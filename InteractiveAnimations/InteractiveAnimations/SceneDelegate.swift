//
//  SceneDelegate.swift
//  CredApp
//
//  Created by Priya Arora on 23/06/20.
//  Copyright © 2020 deeporg. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let tabBarController = UITabBarController()
            tabBarController.tabBar.barTintColor = UIColor(red: 36.0/255, green: 34.0/255, blue: 44.0/255, alpha: 1)
            tabBarController.tabBar.barStyle = .default
            // Create Tabs
            let homeViewCtrl = HomeViewController()
            homeViewCtrl.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
            
            let cardsViewNavCtrl = UINavigationController(rootViewController: CardsViewController())
            cardsViewNavCtrl.isNavigationBarHidden = true
            cardsViewNavCtrl.tabBarItem = UITabBarItem(title: "Cards", image: nil, selectedImage: nil)
            
            let rewardViewCtrl = RewardsViewController()
            rewardViewCtrl.tabBarItem = UITabBarItem(title: "Rewards", image: nil, selectedImage: nil)
        
            tabBarController.setViewControllers([homeViewCtrl, cardsViewNavCtrl, rewardViewCtrl], animated: true)
            tabBarController.selectedIndex = 1
           
            window.rootViewController = tabBarController
            self.window = window
            
            let systemFontAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)]
            UITabBarItem.appearance().setTitleTextAttributes(systemFontAttributes, for: .normal)
            window.makeKeyAndVisible()
        }
    }
    
   
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


