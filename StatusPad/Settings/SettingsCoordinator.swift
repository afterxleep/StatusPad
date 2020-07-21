//
//  SettingsCoordinator.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/19/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsCoordinatorProtocol: CoordinatorProtocol {
    
}

class SettingsCoordinator: SettingsCoordinatorProtocol {
    
    internal let storyBoard = CONSTANTS.STORYBOARDS.STATUS_STORYBOARD.rawValue
    internal var navigationController: UINavigationController
    internal var childCoordinators: [CoordinatorProtocol]
    internal var presenter: SettingsPresenter?
    internal var settingsNavigationController: UINavigationController
    var anchorButton: UIButton
    
    init(with navigationController: UINavigationController, anchorButton: UIButton) {
        self.navigationController = navigationController
        self.anchorButton = anchorButton
        self.childCoordinators = []
        self.settingsNavigationController = UINavigationController()
    }
    
    internal func start() {
        let userSettings: UserSettingsProtocol = UserSettingsDefaults()
        let vc = SettingsViewController.instatiate(fromStoryboard: storyBoard)
        vc.presenter = SettingsPresenter(userSettings: userSettings, coordinator: self)
        settingsNavigationController = UINavigationController(rootViewController: vc)
        settingsNavigationController.modalPresentationStyle = .popover
        settingsNavigationController.popoverPresentationController?.sourceView = anchorButton
        settingsNavigationController.popoverPresentationController?.sourceRect = anchorButton.bounds
        navigationController.present(settingsNavigationController, animated: true, completion: nil)
    }

}
