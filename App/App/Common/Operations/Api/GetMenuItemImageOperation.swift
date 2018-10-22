//
//  GetMenuItemImageOperation.swift
//  App
//
//  Created by Павел Кошара on 18/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import UIKit

final class GetMenuItemImageOperation: DownloadOperation<UIImage> {
    override var request: URLRequest? {
        let url = ApiMap.getImageUrl(path: path)

        return URLRequest(url: url)
    }

    private let path: String

    init(path: String) {
        self.path = path

        super.init()
    }

    override func handleData(_ data: Data) {
        if let image = UIImage(data: data) {
            result = .success(image)
        }
    }
}
