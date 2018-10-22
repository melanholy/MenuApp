//
//  GetMenuMetadataOperation.swift
//  App
//
//  Created by Павел Кошара on 22/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import Foundation

final class GetMenuMetadataOperation: DownloadOperation<MenuMetadata> {
    override var request: URLRequest? {
        return URLRequest(url: ApiMap.getMetadataURL)
    }

    override func handleData(_ data: Data) {
        let jsonDecoder = JSONDecoder()
        if let metadata = try? jsonDecoder.decode(MenuMetadata.self, from: data) {
            self.result = .success(metadata)
        }
    }
}
