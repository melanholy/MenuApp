//
//  OperationWithResult.swift
//  App
//
//  Created by Павел Кошара on 19/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import Foundation

class OperationWithResult<Data>: AsyncOperation {
    var result: Result<Data> = .failure
}
