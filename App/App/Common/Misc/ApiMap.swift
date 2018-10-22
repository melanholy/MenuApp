//
//  ApiMap.swift
//  App
//
//  Created by Павел Кошара on 18/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import Foundation

enum ApiMap {
    static let apiUrl = URL(string: "https://rawgit.com/melanholy/web-tasks/gh-pages/store")!
    static let getMenuItemsURL = apiUrl.appendingPathComponent("/get.json")
    static let getMetadataURL = apiUrl.appendingPathComponent("/metadata.json")

    static func getImageUrl(path: String) -> URL {
        return apiUrl.appendingPathComponent(path)
    }
}
