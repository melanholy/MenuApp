//
//  Dispatcher.swift
//  App
//
//  Created by Павел Кошара on 18/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import Foundation

enum OperationCode {
    case main
    case shared
}

final class Dispatcher {
    private let sharedQueue: OperationQueue
    private let mainQueue: OperationQueue

    init() {
        sharedQueue = OperationQueue()
        sharedQueue.maxConcurrentOperationCount = 8

        mainQueue = OperationQueue.main
    }

    public func add(_ operaion: Operation, withCode code: OperationCode) {
        switch code {
        case .main:
            mainQueue.addOperation(operaion)
        case .shared:
            sharedQueue.addOperation(operaion)
        }
    }
}
