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
    weak var delegate: StatusCoordinatorDelegate?
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    internal func start() {
        let vc = StatusViewController.instatiate(fromStoryboard: storyBoard)
        presenter = StatusPresenter(eventService: EventKitService(),
                                    userSettings: UserSettingsDefaults())
        vc.presenter = presenter
        navigationController.pushViewController(vc, animated: false)
    }
}

extension StatusCoordinator: StatusViewControllerDelegate {}
