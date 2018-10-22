//
//  AppDelegate.swift
//  App
//
//  Created by Павел Кошара on 17/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()

        let storyboard = UIStoryboard(
            name: "MenuViewController",
            bundle: .main
        )
        guard let menuVc = storyboard.instantiateInitialViewController() as? MenuViewController else {
            fatalError()
        }

        // poor man's dependency injection
        let dispatcher = Dispatcher()
        let operationsFactory = DefaultMenuOperationsFactory()
        menuVc.menuItemsProvider = MenuItemsProvider(
            operationsFactory: operationsFactory,
            dispatcher: dispatcher
        )

        window?.rootViewController = menuVc
        window?.makeKeyAndVisible()

        return true
    }
}
