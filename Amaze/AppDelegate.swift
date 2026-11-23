//
//  AppDelegate.swift
//  Amaze
//
//  Created by Scott Tury on 9/18/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    // Kept for the pre-iOS 13 app lifecycle. iOS 13 and later create windows
    // for individual scenes in SceneDelegate.
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // SceneDelegate configures the UI on iOS 13 and later.
        guard #available(iOS 13.0, *) else {
            if let splitViewController = window?.rootViewController as? UISplitViewController {
                configureSplitViewController(splitViewController, delegate: self)
            }
            return true
        }
        return true
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Pause ongoing tasks and invalidate graphics rendering callbacks as needed.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Save user data and release shared resources as needed.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Undo changes made on entering the background as needed.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart tasks that were paused while the application was inactive.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Save data if appropriate.
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryNavigationController = secondaryViewController as? UINavigationController,
              let detailController = secondaryNavigationController.topViewController as? DetailViewController else {
            return false
        }

        // Discard the empty detail controller when the split view collapses.
        return detailController.helper == nil
    }
}

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let splitViewController = storyboard.instantiateInitialViewController() as? UISplitViewController else {
            return
        }

        configureSplitViewController(splitViewController, delegate: self)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = splitViewController
        self.window = window
        window.makeKeyAndVisible()
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryNavigationController = secondaryViewController as? UINavigationController,
              let detailController = secondaryNavigationController.topViewController as? DetailViewController else {
            return false
        }

        // Discard the empty detail controller when the split view collapses.
        return detailController.helper == nil
    }
}

private func configureSplitViewController(_ splitViewController: UISplitViewController, delegate: UISplitViewControllerDelegate) {
    if let navigationController = splitViewController.viewControllers.last as? UINavigationController {
        navigationController.topViewController?.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
    }
    splitViewController.delegate = delegate
}
