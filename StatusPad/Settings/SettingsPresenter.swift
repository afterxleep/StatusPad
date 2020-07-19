//
//  SettingsPresenter.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/19/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

class SettingsPresenter: BasePresenter {
    
    typealias View = SettingsView
    private var settingsView: SettingsView?
    
    internal func attachView(view: SettingsView) {
        settingsView = view
    }
    
    internal func detachView() {
        settingsView = nil
    }
    
    internal func destroy() {
        
    }

}
