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
    
    enum DefaultStatus: String {
        case available = "Available"
        case onACall = "On a Call"
        case inAMeeting = "In a Meeting"
        case busy = "Busy"
    }
        
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
            return StatusViewData(title:  DefaultStatus.available.rawValue, style: .free)
        }
        
        var title: String = event.title
        if(!event.displayTitle) {
            switch(event.type) {
                case .call:
                    title = DefaultStatus.onACall.rawValue
                case .meeting:
                    title = DefaultStatus.onACall.rawValue
                case .other:
                    title = DefaultStatus.busy.rawValue
            }
        }
        return StatusViewData(title: title,
                              style: (event.availalibility == .free) ? .free : .busy)
    }
}
