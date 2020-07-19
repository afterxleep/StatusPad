//
//  SettingsCoordinator.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/19/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsCoordinatorDelegate: class {}

class SettingsCoordinator: Coordinator {
    
    internal let storyBoard = CONSTANTS.STORYBOARDS.STATUS_STORYBOARD.rawValue
    internal var navigationController: UINavigationController
    internal var childCoordinators: [Coordinator]
    internal var presenter: SettingsPresenter?
    internal var settingsNavigationController: UINavigationController
    weak var delegate: SettingsCoordinatorDelegate?
    var anchorButton: UIButton
    
    init(with navigationController: UINavigationController, anchorButton: UIButton) {
        self.navigationController = navigationController
        self.anchorButton = anchorButton
        self.childCoordinators = []
        self.settingsNavigationController = UINavigationController()
    }
    
    internal func start() {
        let vc = SettingsViewController.instatiate(fromStoryboard: storyBoard)
        settingsNavigationController = UINavigationController(rootViewController: vc)
        settingsNavigationController.modalPresentationStyle = .popover
        settingsNavigationController.popoverPresentationController?.sourceView = anchorButton
        settingsNavigationController.popoverPresentationController?.sourceRect = anchorButton.bounds
        navigationController.present(settingsNavigationController, animated: true, completion: nil)
    }

}
