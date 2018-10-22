//
//  MenuItemViewModel.swift
//  App
//
//  Created by Павел Кошара on 19/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import UIKit

struct MenuItemViewModel {
    let name: String
    let image: UIImage?
    let price: String

    init(item: MenuItem, image: UIImage?) {
        self.price = priceString(from: item.price)
        self.name = item.name
        self.image = image
    }
}

private func priceString(from price: Double) -> String {
    // должно, конечно, зависеть от локали, но для простоты доллары
    return floor(price) == price ? "$\(Int(price))" : "$\(price)"
}
