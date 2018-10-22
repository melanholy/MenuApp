//
//  DefaultMenuOperationsFactory.swift
//  App
//
//  Created by Павел Кошара on 19/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import UIKit

final class DefaultMenuOperationsFactory: MenuOperationsFactory {
    func buildGetMenuItemsOperation(skip: Int, take: Int) -> OperationWithResult<[MenuItem]> {
        return GetMenuItemsOperation(skip: skip, take: take)
    }

    func buildGetMenuItemImageOperation(path: String) -> OperationWithResult<UIImage> {
        return GetMenuItemImageOperation(path: path)
    }

    func buildGetMenuMetadataOperation() -> OperationWithResult<MenuMetadata> {
        return GetMenuMetadataOperation()
    }
}
