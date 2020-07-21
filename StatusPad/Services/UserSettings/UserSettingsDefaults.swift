//
//  UserSettingsDefaults.swift
//  StatusPad
//
//  Created by Daniel Bernal on 3/25/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation



final class UserSettingsDefaults: UserSettingsProtocol {
    
    init() {
        let c1 = Calendar(title: "StatusPad", displayTitles: true)
        let c2 = Calendar(title: "FastMail", displayTitles: false)
        self.activeCalendars = [c1, c2]        
        self.dimScreenWhenInactive = true
    }
    
    private func sync() {
        UserDefaults.standard.synchronize()
    }
    
    var activeCalendars: [Calendar] {
        get {
            var calendars: [Calendar] = []
            if let data = UserDefaults.standard.data(forKey: USER_SETTINGS.CALENDARS.rawValue) {
                let decoder = JSONDecoder()
                calendars = (try? decoder.decode([Calendar].self, from: data)) ?? []
            }
            return calendars
        }
        set {
            let encoder = JSONEncoder()
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: USER_SETTINGS.CALENDARS.rawValue)
            sync()
        }
    }
    
    var dimScreenWhenInactive: Bool {
        get { UserDefaults.standard.bool(forKey: USER_SETTINGS.DIM_SCREEN_WHEN_INACTIVE.rawValue) }
        set {
            UserDefaults.standard.set(newValue, forKey: USER_SETTINGS.DIM_SCREEN_WHEN_INACTIVE.rawValue)
            sync()
        }
    }
    
    var hasLaunchedApp: Bool {
        get { UserDefaults.standard.bool(forKey: USER_SETTINGS.HAS_LAUNCHED_APP.rawValue) }
        set {
            UserDefaults.standard.set(newValue, forKey: USER_SETTINGS.HAS_LAUNCHED_APP.rawValue)
            sync()
        }
    }
    
    var defaultEventStatus: [String : Any] {
        get { UserDefaults.standard.dictionary(forKey: USER_SETTINGS.DEFAULT_EVENT_STATUS.rawValue) ??
            [
                EventAvailability.busy.rawValue : EventAvailability.busy.rawValue.capitalized,
                EventAvailability.free.rawValue : EventAvailability.free.rawValue.capitalized
            ]
            
        }
        set {
            UserDefaults.standard.set(newValue, forKey: USER_SETTINGS.DEFAULT_EVENT_STATUS.rawValue)
            sync()
        }
    }
}
