//
//  UserSettings.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/1/20.
//

import Foundation

protocol UserSettings {
    var hasLaunchedApp: Bool { get set }
    var activeCalendars: [Calendar] { get set }
}
