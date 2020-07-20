//
//  SettingsViewController.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/19/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, SettingsView, Storyboardeable {
    
    enum DisplayStrings: String {
        case settings = "Settings"
    }
    
    var presenter: SettingsPresenter!    

    override func viewDidLoad() {
        self.title = DisplayStrings.settings.rawValue
        setupUI()
    }
    
    @IBOutlet weak var calendarSelectCell: UITableViewCell!
    @IBOutlet weak var availableTxt: UITextField!
    @IBOutlet weak var busyTxt: UITextField!
    @IBOutlet weak var dimSwitch: UISwitch!
    
    func setupUI() {
        availableTxt.text = presenter.getAvailableTextData().text
        availableTxt.placeholder = presenter.getAvailableTextData().placeholder
        busyTxt.text = presenter.getBusyTextData().text
        busyTxt.placeholder = presenter.getBusyTextData().placeholder
        dimSwitch.isOn = presenter.dimScreenWhenInactive()
    }

}
