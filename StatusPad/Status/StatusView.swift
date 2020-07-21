//
//  StatusView.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/15/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation

protocol StatusView {
    var presenter: StatusPresenter? { get set }    
    func didTapSettings()
    func presentData(data: StatusViewData)
}
