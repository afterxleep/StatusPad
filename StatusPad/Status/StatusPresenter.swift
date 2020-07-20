//
//  StatusViewModel.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/14/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

class StatusPresenter: BasePresenter {
    
    typealias View = StatusView
    private var statusView: StatusView?
    private static let timerInterval = 60.0
    private var eventService: EventService
    private var userSettings: UserSettings
    private var timer: Timer?
    private var events: [Event] = []
            
    var displayEvents: (current: Event?, next: Event?)
    
    var shouldDimScreen: Bool {
        get { return userSettings.dimScreenWhenInactive }
    }
    
    internal func attachView(view: StatusView) {
        statusView = view
    }
    
    internal func detachView() {
        statusView = nil
    }
    
    internal func destroy() {}

    init(eventService: EventService, userSettings: UserSettings) {
        self.userSettings = userSettings
        self.eventService = eventService
        self.eventService.limitToCalendars = userSettings.activeCalendars
        self.userSettings.hasLaunchedApp = true
    }
    
    func getDisplayData() -> StatusViewData {
        guard let event = eventService.getCurrentEvent() else {
            return StatusViewData(title: userSettings.defaultEventStatus[EventAvailability.free.rawValue] as! String, style: .free)
        }
        
        var title: String = event.title
        if(!event.displayTitle) {
            switch(event.type) {
                case .call:
                    title = userSettings.defaultEventStatus[EventAvailability.busy.rawValue] as! String
                case .meeting:
                    title = userSettings.defaultEventStatus[EventAvailability.busy.rawValue] as! String
                case .other:
                    title = userSettings.defaultEventStatus[EventAvailability.busy.rawValue] as! String
            }
        }
        return StatusViewData(title: title,
                              style: (event.availalibility == .free) ? .free : .busy)
    }
}
