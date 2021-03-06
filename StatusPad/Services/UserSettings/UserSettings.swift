//
//  UserSettings.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/1/20.
//

import Foundation

enum USER_SETTINGS: String {
    case HAS_LAUNCHED_APP
    case CALENDARS
    case DIM_SCREEN_WHEN_INACTIVE
}

protocol UserSettings {
    var hasLaunchedApp: Bool { get set }
    var activeCalendars: [Calendar] { get set }
    var dimScreenWhenInactive: Bool { get set }
}
