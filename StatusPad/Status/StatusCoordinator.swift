//
//  StatusCoordinator.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/16/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

protocol StatusCoordinatorDelegate: class {}

class StatusCoordinator: Coordinator {
    
    internal let storyBoard = CONSTANTS.STORYBOARDS.STATUS_STORYBOARD.rawValue
    internal var navigationController: UINavigationController
    internal var childCoordinators: [Coordinator]
    internal var presenter: StatusPresenter?
    var delegate: StatusCoordinatorDelegate?
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    internal func start() {
        let userSettings = UserSettingsDefaults()
        presenter = StatusPresenter(eventService: EventKitService(userSettings: userSettings),
                                    userSettings: userSettings)
        let vc = StatusViewController.instatiate(fromStoryboard: storyBoard)
        vc.presenter = presenter
        vc.delegate = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func settingsFrom(anchorButton: UIButton) {
        let settingsCoordinator = SettingsCoordinator(with: navigationController, anchorButton: anchorButton)
        addChild(coordinator: settingsCoordinator)        
        settingsCoordinator.start()
    }
    
    
}

extension StatusCoordinator: StatusViewControllerDelegate {
    
    func didTapSettings(anchorButton: UIButton) {
        settingsFrom(anchorButton: anchorButton)
    }
}
