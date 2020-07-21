//
//  ViewController.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/14/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController, Storyboardeable {
    
    var presenter: StatusPresenter?
    private static let timerInterval = 60.0
    private var dataTimer: Timer?
    private var screenTimer: Timer?
    
    @IBOutlet weak var statusLbl: UILabel!    
    @IBOutlet weak var settingsBtn: UIButton!
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIScreen.main.wantsSoftwareDimming = true
        presenter?.attachView(view: self)
        setupUI()
        disableSleepTimer()
        displayData()
        setDataTimer()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: IBActions
    @IBAction func didTapScreen(_ sender: Any) {
        presenter?.isPresentingSettings = false
        enableScreen()
    }

    @IBAction func didTapSettingsBtn(_ sender: Any) {
        presenter?.isPresentingSettings = true
    }
    
    
    // MARK: Internal Methods
    internal func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        statusLbl.numberOfLines = 8
    }

    private func setDataTimer() {
        self.dataTimer = Timer.scheduledTimer(timeInterval: Self.timerInterval,
                                          target: self,
                                          selector: #selector(displayData),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    private func disableScreen() {
        UIScreen.main.brightness = 0.0
        UIDevice.current.isProximityMonitoringEnabled = true
    }
    
    private func enableScreen() {
        UIScreen.main.brightness = CONSTANTS.CONFIG.DEFAULT_BRIGHTNESS
    }
    
    @objc private func displayData() {
        guard let data = presenter?.getDisplayData() else { return }
        presentData(data: data)
        if let dim = presenter?.shouldDimScreen, let isPresenting = presenter?.isPresentingSettings {
            if (dim && data.style == .free && !isPresenting) {
                disableScreen()
            } else {
                enableScreen()
            }
        }
    }

    private func disableSleepTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
    }

}

extension StatusViewController: StatusView {
    
    func didTapSettings() {}
    
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
}
