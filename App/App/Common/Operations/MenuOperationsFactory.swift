//
//  MenuOperationsFactory.swift
//  App
//
//  Created by Павел Кошара on 19/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import UIKit

protocol MenuOperationsFactory {
    func buildGetMenuItemsOperation(skip: Int, take: Int) -> OperationWithResult<[MenuItem]>
    func buildGetMenuItemImageOperation(path: String) -> OperationWithResult<UIImage>
    func buildGetMenuMetadataOperation() -> OperationWithResult<MenuMetadata>
}
