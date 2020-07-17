//
//  Coordinator.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/16/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    func start()
    func addChild(coordinator: Coordinator)
    func removeChild(coordinator: Coordinator)
}

extension Coordinator {
    
    func addChild(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
}
