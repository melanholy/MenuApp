//
//  MenuItemsProvider.swift
//  App
//
//  Created by Павел Кошара on 22/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import UIKit

protocol MenuItemsProviderDelegate: class {
    func metadataLoaded()
    func itemsLoaded(from: Int, to: Int)
    func imageLoaded(forItemAtIndex: Int)
    func errorOccured()
}

final class MenuItemsProvider: NSObject {
    typealias PageIndex = Int

    enum Status: String {
        case uninitialized
        case normal
        case error
    }

    private(set) var status = Status.uninitialized
    private(set) var itemsCount: Int?
    var delegate: MenuItemsProviderDelegate?

    private let operationsFactory: MenuOperationsFactory
    private let dispatcher: Dispatcher
    private let itemsInPage = Constants.menuItemsProviderPageSize
    private var items = [PageIndex: [MenuItem]]()
    private var images = [Int: UIImage]()
    private var loadingPages = Set<PageIndex>()

    init(operationsFactory: MenuOperationsFactory, dispatcher: Dispatcher) {
        self.operationsFactory = operationsFactory
        self.dispatcher = dispatcher
    }

    func loadMetadata() {
        status = .uninitialized

        let metadataOp = operationsFactory.buildGetMenuMetadataOperation()
        let getResultOp = BlockOperation { [weak self] in
            guard let sself = self else {
                return
            }

            switch metadataOp.result {
            case .failure:
                sself.handleError()
            case let .success(metadata):
                sself.itemsCount = metadata.itemsCount
            }

            sself.status = .normal
            sself.delegate?.metadataLoaded()
        }

        getResultOp.addDependency(metadataOp)
        dispatcher.add(metadataOp, withCode: .shared)
        dispatcher.add(getResultOp, withCode: .main)
    }

    func loadPageForItem(at index: Int, prefetchNextPage: Bool = true) {
        defer {
            if prefetchNextPage {
                loadPageForItem(at: index + itemsInPage, prefetchNextPage: false)
            }
        }

        let page = index / itemsInPage
        guard items[page] == nil,
            !loadingPages.contains(page),
            let itemsCount = itemsCount,
            index < itemsCount else {
                return
        }
        loadingPages.insert(page)

        let pageStart = page * itemsInPage

        let getItemsOp = operationsFactory.buildGetMenuItemsOperation(skip: pageStart, take: itemsInPage)
        let getResultOp = BlockOperation { [weak self] in
            self?.handleItemsResult(getItemsOp.result, from: pageStart, page: page)
        }

        getResultOp.addDependency(getItemsOp)
        dispatcher.add(getItemsOp, withCode: .shared)
        dispatcher.add(getResultOp, withCode: .main)
    }

    func viewModel(at index: Int) -> MenuItemViewModel? {
        let page = index / itemsInPage
        let offset = index % itemsInPage
        let item = items[page]?[offset]

        return item.flatMap {
            MenuItemViewModel(item: $0, image: images[index])
        }
    }

    private func handleError() {
        status = .error
        itemsCount = nil
        items = [:]
        images = [:]
        loadingPages = Set<PageIndex>()

        delegate?.errorOccured()
    }

    private func handleItemsResult(_ result: Result<[MenuItem]>, from: Int, page: PageIndex) {
        loadingPages.remove(page)

        guard status == .normal else {
            return
        }

        switch result {
        case .failure:
            handleError()
        case let .success(items):
            self.items[page] = items
            delegate?.itemsLoaded(
                from: from,
                to: from + items.count - 1
            )
            loadImages(forPage: page)
        }
    }

    private func loadImages(forPage page: PageIndex) {
        guard let batch = items[page] else {
            return
        }

        let pageStartIndex = page * itemsInPage
        for (i, item) in batch.enumerated() {
            let loadImageOp = operationsFactory.buildGetMenuItemImageOperation(path: item.imagePath)
            let getResultOp = BlockOperation { [weak self, i] in
                guard let sself = self, sself.status == .normal else {
                    return
                }

                switch loadImageOp.result {
                case .failure:
                    sself.handleError()
                case let .success(image):
                    sself.images[pageStartIndex + i] = image
                    sself.delegate?.imageLoaded(forItemAtIndex: pageStartIndex + i)
                }
            }

            getResultOp.addDependency(loadImageOp)
            dispatcher.add(loadImageOp, withCode: .shared)
            dispatcher.add(getResultOp, withCode: .main)
        }
    }
}
