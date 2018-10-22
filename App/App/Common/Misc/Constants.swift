//
//  Constants.swift
//  App
//
//  Created by Павел Кошара on 22/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import UIKit

enum Constants {
    static let menuItemsProviderPageSize = 13

    static let spinnerImages = {
        return (0..<30).map {
            "Spinner/frame-\($0)"
        }.map {
            UIImage(named: $0)!
        }
    }()
}
