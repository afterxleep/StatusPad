//
//  Event.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/14/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation

enum EventAvailability: String, Codable {
    case busy = "busy"
    case free = "available"
}

enum EventType: String, Codable {
    case meeting
    case call
    case other
}

struct Event: Codable {
    var title: String    
    var startDate: Date
    var endDate: Date
    var allDay: Bool = false    
    var type: EventType = .other
    var displayTitle: Bool = false
    var availalibility: EventAvailability = .free
    var location: String?
    var url: String?
    
}
