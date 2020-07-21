//
//  Coordinator.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/16/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: class {
    
    var navigationController: UINavigationController { get }
    var childCoordinators: [CoordinatorProtocol] { get set }
    func start()
    func addChild(coordinator: CoordinatorProtocol)
    func removeChild(coordinator: CoordinatorProtocol)
}

extension CoordinatorProtocol {
    
    func addChild(coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(coordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
}
