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
    
    var presenter: StatusPresenter?
    private static let timerInterval = 60.0
    private var timer: Timer?
    
    @IBOutlet weak var statusLbl: UILabel!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(view: self)
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
        let data = presenter?.viewData
        var labelColor: UIColor
        switch(data?.style) {
            case .busy:
                labelColor = UIColor.systemPink
            case .free:
                labelColor = UIColor.systemGreen
            case .none:
                labelColor = UIColor.systemBlue
        }
        statusLbl.text = data?.title.uppercased()        
        view.backgroundColor = labelColor        
    }

    
    private func disableSleepTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
}

