//
//  ViewController.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/14/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import UIKit

protocol StatusViewControllerDelegate: class {}

class StatusViewController: UIViewController, StatusView, Storyboardeable {
    
    var presenter: StatusPresenter!
    private static let timerInterval = 60.0
    private var timer: Timer?
    
    @IBOutlet weak var statusLbl: UILabel!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(view: self)
        setupUI()
        disableSleepTimer()
        displayData()
        setTimer()
    }
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        statusLbl.numberOfLines = 8
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: Self.timerInterval,
                                          target: self,
                                          selector: #selector(displayData),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    @objc private func displayData() {
        
        UIScreen.main.wantsSoftwareDimming = true
        UIScreen.main.brightness = CONSTANTS.CONFIG.DEFAULT_BRIGHTNESS
        if (presenter.shouldDimScreen) {
            statusLbl.text = ""
            UIScreen.main.brightness = 0.0
            view.backgroundColor = UIColor.black
            return
        }
        
        let data = presenter.getDisplayData()
        var bgColor: UIColor
        switch(data.style) {
            case .busy:
                bgColor = UIColor.systemPink
            case .free:
                bgColor = UIColor.systemGreen            
        }
        statusLbl.text = data.title.uppercased()
        view.backgroundColor = bgColor
    }

    
    private func disableSleepTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
}

