//
//  GetMenuItemsOperation.swift
//  App
//
//  Created by Павел Кошара on 18/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import Foundation

final class GetMenuItemsOperation: DownloadOperation<[MenuItem]> {
    override var request: URLRequest? {
        let components = NSURLComponents(url: ApiMap.getMenuItemsURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            NSURLQueryItem(name: "skip", value: "\(skip)"),
            NSURLQueryItem(name: "take", value: "\(take)")
        ] as [URLQueryItem]

        return (components?.url).flatMap {
            URLRequest(url: $0)
        }
    }

    private let skip: Int
    private let take: Int

    init(skip: Int, take: Int) {
        self.skip = skip
        self.take = take

        super.init()
    }

    override func handleData(_ data: Data) {
        let jsonDecoder = JSONDecoder()
        if let items = try? jsonDecoder.decode([MenuItem].self, from: data) {
            self.result = .success(items)
        }
    }
}
