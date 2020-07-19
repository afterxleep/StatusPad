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
    weak var delegate: SettingsCoordinatorDelegate?
    var anchorButton: UIButton
    
    init(with navigationController: UINavigationController, anchorButton: UIButton) {
        self.navigationController = navigationController
        self.anchorButton = anchorButton
        self.childCoordinators = []
    }
    
    internal func start() {
        let vc = SettingsViewController.instatiate(fromStoryboard: storyBoard)
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceView = anchorButton
        vc.popoverPresentationController?.sourceRect = anchorButton.bounds
        navigationController.present(vc, animated: true, completion: nil)
    }

}
