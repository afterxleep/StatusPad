//
//  ViewController.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/14/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import UIKit

protocol StatusViewControllerDelegate: class {
    func didTapSettings(anchorButton: UIButton)
}

class StatusViewController: UIViewController, StatusView, Storyboardeable {
    
    var presenter: StatusPresenter!
    private static let timerInterval = 60.0
    private var dataTimer: Timer?
    private var screenTimer: Timer?
    var delegate: StatusViewControllerDelegate?
    
    @IBOutlet weak var statusLbl: UILabel!    
    @IBOutlet weak var settingsBtn: UIButton!
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIScreen.main.wantsSoftwareDimming = true
        presenter.attachView(view: self)
        setupUI()
        disableSleepTimer()
        displayData()
        setDataTimer()
    }
    
    //MARK: IBActions
    @IBAction func didTapScreen(_ sender: Any) {
        enableScreen()
    }

    @IBAction func didTapSettingsBtn(_ sender: Any) {
        delegate?.didTapSettings(anchorButton: settingsBtn)
    }
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        statusLbl.numberOfLines = 8
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setDataTimer() {
        self.dataTimer = Timer.scheduledTimer(timeInterval: Self.timerInterval,
                                          target: self,
                                          selector: #selector(displayData),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    func disableScreen() {
        UIScreen.main.brightness = 0.0
    }
    
    func enableScreen() {
        UIScreen.main.brightness = CONSTANTS.CONFIG.DEFAULT_BRIGHTNESS
    }
        
    func presentData(data: StatusViewData) {
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
    
    @objc private func displayData() {
        let data = presenter.getDisplayData()
        presentData(data: data)
        if (presenter.shouldDimScreen && data.style == .free) {
            disableScreen()
        } else {
            enableScreen()
        }
    }

    private func disableSleepTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
}

