//
//  SettingsPresenter.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/19/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

class SettingsPresenter: BasePresenterProtocol {
    
    typealias View = SettingsView    
    var coordinator: SettingsCoordinatorProtocol
    var userSettings: UserSettingsProtocol
    
    private var settingsView: SettingsView?
    
    init(userSettings: UserSettingsProtocol, coordinator: SettingsCoordinatorProtocol) {
        self.userSettings = userSettings
        self.coordinator = coordinator
    }
    
    internal func attachView(view: SettingsView) {
        settingsView = view
    }
    
    internal func detachView() {
        settingsView = nil
    }
    
    internal func destroy() {
        
    }
    
    func getAvailableTextData() -> (placeholder: String, text: String?) {
        let availablePlaceholder = EventAvailability.free.rawValue.capitalized
        let availableText = userSettings.defaultEventStatus[EventAvailability.free.rawValue] as? String
        return (availablePlaceholder, (availableText == availablePlaceholder) ? "" : availableText)
    }
    
    func getBusyTextData() -> (placeholder: String, text: String?) {
        let busyText = userSettings.defaultEventStatus[EventAvailability.busy.rawValue] as? String
        let busyPlaceholder = EventAvailability.busy.rawValue.capitalized
        return (busyPlaceholder, (busyText == busyPlaceholder) ? "" : busyText)
    }
    
    func dimScreenWhenInactive() -> Bool {
        return userSettings.dimScreenWhenInactive
    }
    

}
