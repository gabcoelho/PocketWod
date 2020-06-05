//
//  AppDelegate.swift
//  PocketWod
//
//  Created by Gabriela Coelho on 02/04/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PocketWod")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
}

