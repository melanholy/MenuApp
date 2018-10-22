//
//  UIDevice+App.swift
//  App
//
//  Created by Павел Кошара on 17/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import UIKit

extension UIDevice {
    var isPortraitOrientation: Bool {
        switch orientation {
        case .faceDown, .faceUp, .portrait, .portraitUpsideDown, .unknown:
            return true
        case .landscapeLeft, .landscapeRight:
            return false
        }
    }

    var isIphone: Bool {
        switch userInterfaceIdiom {
        case .phone:
            return true
        default:
            return false
        }
    }
}
