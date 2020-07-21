//
//  EventModel.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/14/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import EventKit

class EventServiceEventKit: EventServiceProtocol {
    
    static let nextEventsInterval: Double = +30*24*3600*4
    static let previousEventsInterval: Double = -30*24*3600*4
    private let eventStore = EKEventStore()
    
    var limitToCalendars: [Calendar] = []
    var events: [Event] = []
    var eventDefaults: [String : Any]? = ["busy": "Busy", "available": "Available"]
    
    init(eventDefaults: [String : Any]) {
        self.eventDefaults = eventDefaults
        setupNotifications()
        fetchEvents()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.fetchEvents),
                                               name: .EKEventStoreChanged,
                                               object: eventStore)
    }
    
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
            self.eventDefaults?[EventAvailability.busy.rawValue] as! String :
            self.eventDefaults?[EventAvailability.free.rawValue] as! String
    }
    
    private func eventAvailability(event: EKEvent) -> EventAvailability {
        switch (event.availability) {
            case .busy, .unavailable, .notSupported:
                return .busy
            case .tentative, .free:
                return .free
            @unknown default:
                return .free
        }
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
            if([0,1].contains(event.status.rawValue) && [0,1,3].contains(event.availability.rawValue)) {
                let title = ((displayTitles) ? event.title : eventIncognitoTitle(event: event)) ?? ""
                let e = Event(title: title,
                              startDate: event.startDate,
                              endDate: event.endDate,
                              type: .other,
                              displayTitle: displayTitles,
                              availalibility: eventAvailability(event: event))
                nextEvents.append(e)
            }
        }
        return nextEvents.filter({ $0.endDate > Date() })
    }
        
    @objc private func fetchEvents() {        
        if(!isAccessAuthorized()) {
            self.events = []
        }
        var events: [Event] = []
        for calendar in availableCalendars() {
            let calendarSettings = limitToCalendars.filter({$0.title == calendar.title}).first
            if(limitToCalendars.count == 0  || calendarSettings != nil) {
                events.append(contentsOf: nextEventsForCalendar(calendar: calendar, displayTitles: calendarSettings?.displayTitles ?? false))
            }
        }
        self.events = events.sorted(by: { $0.startDate < $1.startDate })
    }
    
    
    func getCurrentEvent() -> Event? {
        guard let event = events.first else {
            return nil
        }
        let now = Date()
        if(event.startDate < now && event.endDate > now) {
            return event
        }
        return nil
        
    }
}
