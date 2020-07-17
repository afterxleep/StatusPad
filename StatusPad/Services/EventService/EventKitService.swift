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
    
    static let nextEventsInterval: Double = +30*24*3600*4
    static let previousEventsInterval: Double = -30*24*3600*4
    
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
        let startInterval = NSDate(timeIntervalSinceNow: Self.previousEventsInterval)
        let endInterval = NSDate(timeIntervalSinceNow: Self.nextEventsInterval)
        let predicate = eventStore.predicateForEvents(withStart: startInterval as Date, end: endInterval as Date, calendars: [calendar])
        let events = eventStore.events(matching: predicate)
        for event in events {
            // Only return Confirmed and blocked slots
            if([0,1].contains(event.status.rawValue) && event.availability.rawValue == 0) {
                let title = ((displayTitles) ? event.title : eventIncognitoTitle(event: event)) ?? ""
                let e = Event(title: title,
                              startDate: event.startDate,
                              endDate: event.endDate,
                              type: ((event.location) != nil) ? .meeting : (event.url != nil) ? .call : .other,
                              displayTitle: displayTitles)
                nextEvents.append(e)
            }
        }
        return nextEvents.filter({ $0.endDate > Date() })
    }
        
    internal func getEvents() -> [Event] {
        if(!isAccessAuthorized()) {
            return []
        }
        var events: [Event] = []
        for calendar in availableCalendars() {
            let calendarSettings = limitToCalendars.filter({$0.title == calendar.title}).first
            if(limitToCalendars.count == 0  || calendarSettings != nil) {
                events.append(contentsOf: nextEventsForCalendar(calendar: calendar, displayTitles: calendarSettings?.displayTitles ?? false))
            }
        }
        print(events.sorted(by: { $0.startDate < $1.startDate }))
        return events.sorted(by: { $0.startDate < $1.startDate })
    }
    
    
    func getCurrentEvent() -> Event? {
        guard let event = getEvents().first else {
            return nil
        }
        let now = Date()
        if(event.startDate < now && event.endDate >= now) {
            return event
        }
        return nil
        
    }
}
