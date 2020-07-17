//
//  DisplayData.swift
//  StatusPad
//
//  Created by Daniel Bernal on 7/16/20.
//  Copyright © 2020 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

enum DisplayStyle {
    case busy
    case free
}

struct StatusViewData {
    var title: String
    var details: String
    var style: DisplayStyle
}
