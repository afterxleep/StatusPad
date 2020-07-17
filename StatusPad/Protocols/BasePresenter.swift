//
//  BasePresneter.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/15/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation

protocol BasePresenter {
    
    associatedtype View
    
    func attachView(view: View)
    func detachView()
    func destroy()
    
}
