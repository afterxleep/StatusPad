//
//  EventService.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/14/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation

protocol EventService {
    
    var limitToCalendars: [Calendar] { get set }
    var events: [Event] { get }
    func getCurrentEvent() -> Event?
}
