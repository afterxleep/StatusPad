//
//  AppCoordinator.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/16/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    private var window: UIWindow
    internal var navigationController: UINavigationController
    internal var childCoordinators: [Coordinator]
        
    var rootViewController: UIViewController {
        return navigationController
    }
    
    init(in window: UIWindow) {
        self.childCoordinators = []
        self.navigationController = UINavigationController()
        self.window = window
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        let userSettings: UserSettings = UserSettingsDefaults()
        if(userSettings.hasLaunchedApp) {
            status()
        }
    }
    
    func status() {
        let statusCoordinator = StatusCoordinator(with: navigationController)
        statusCoordinator.delegate = self
        addChild(coordinator: statusCoordinator)
        statusCoordinator.start()
    }
    
    func onboardView() {
        
    }
}

extension AppCoordinator: StatusCoordinatorDelegate {}


