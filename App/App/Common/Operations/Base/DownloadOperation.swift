//
//  DownloadOperation.swift
//  App
//
//  Created by Павел Кошара on 18/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import Foundation

class DownloadOperation<TData>: OperationWithResult<TData> {
    var request: URLRequest? {
        fatalError("Must override")
    }

    override func main() {
        guard let request = request else {
            finish()
            return
        }

        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let sself = self else {
                return
            }

            defer {
                sself.finish()
            }

            guard error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data else {
                    sself.handleError()
                    return
            }

            sself.handleData(data)
        }.resume()
    }

    func handleError() {}

    func handleData(_ data: Data) {
        fatalError("Must override")
    }
}
