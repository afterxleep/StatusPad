//
//  StatusCoordinator.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/16/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

protocol StatusCoordinatorProtocol: CoordinatorProtocol {
    func settingsFrom(anchorButton: UIButton)
}

class StatusCoordinator: StatusCoordinatorProtocol {
    
    internal let storyBoard = CONSTANTS.STORYBOARDS.STATUS_STORYBOARD.rawValue
    internal var navigationController: UINavigationController
    internal var childCoordinators: [CoordinatorProtocol]
    internal var presenter: StatusPresenter?
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    internal func start() {
        let userSettings: UserSettingsProtocol = UserSettingsDefaults()
        let eventService: EventServiceProtocol = EventServiceEventKit(eventDefaults: userSettings.defaultEventStatus)
        let vc = StatusViewController.instatiate(fromStoryboard: storyBoard)
        vc.presenter = StatusPresenter(eventService: eventService,
                                       userSettings: userSettings,
                                       coordinator: self)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func settingsFrom(anchorButton: UIButton) {
        let settingsCoordinator = SettingsCoordinator(with: navigationController, anchorButton: anchorButton)
        addChild(coordinator: settingsCoordinator)        
        settingsCoordinator.start()
    }
}
