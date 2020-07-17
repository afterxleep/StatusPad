//
//  EventModel.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/14/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import EventKit

struct EventKitService: EventService {
    
    enum EventAvailabilityStrings: String {
        case busy = "Busy"
        case available = "Available"
    }
    
    static let nextEventsInterval: Double = +30*24*3600
    
    let eventStore = EKEventStore()
    var limitToCalendars: [Calendar] = []
    
    private func isAccessAuthorized() -> Bool  {
        var result: Bool = false
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
            case .authorized:
                result = true
            case .denied:
                result = false
            case .notDetermined:
                eventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                    if granted {
                        result = true
                    }
                })
            case .restricted:
                result = false
            @unknown default:
                result = false
        }
        return result
    }
    
    private func eventIncognitoTitle(event: EKEvent) -> String {
        return (event.availability.rawValue == 0) ?
                EventAvailabilityStrings.busy.rawValue :
                EventAvailabilityStrings.available.rawValue
    }
    
    private func availableCalendars() -> [EKCalendar] {
        let calendars = eventStore.calendars(for: .event)
        return calendars
    }
    
    private func nextEventsForCalendar(calendar: EKCalendar, displayTitles: Bool) -> [Event] {
        var nextEvents: [Event] = []
        let now = NSDate()
        let nextWeek = NSDate(timeIntervalSinceNow: Self.nextEventsInterval)
        let predicate = eventStore.predicateForEvents(withStart: now as Date, end: nextWeek as Date, calendars: [calendar])
        let events = eventStore.events(matching: predicate)
        for event in events {
            // Only return Confirmed and blocked slots
            if([0,1].contains(event.status.rawValue) && event.availability.rawValue == 0) {
                let title = (displayTitles) ? event.title : eventIncognitoTitle(event: event)
                let details = (displayTitles) ? event.description : ""
                let e = Event(title: (displayTitles) ? event.title : eventIncognitoTitle(event: event), details: details,
                              startDate: event.startDate,
                              endDate: event.endDate)
                nextEvents.append(e)
            }
        }
        return nextEvents
    }
        
    func nextEvents() -> [Event] {
        if(!isAccessAuthorized()) {
            return []
        }
        var nextEvents: [Event] = []
        for calendar in availableCalendars() {
            if(limitToCalendars.count == 0  || limitToCalendars.filter({$0.title == calendar.title}).count > 0) {
                nextEvents.append(contentsOf: nextEventsForCalendar(calendar: calendar, displayTitles: false))
            }
        }
        return nextEvents
    }
    
    func currentEvent() -> Event? {
        guard let event = nextEvents().first else {
            return nil
        }
        let now = Date()
        if(event.startDate < now && event.endDate <= now) {
            return event
        }
        return nil
    }
}
