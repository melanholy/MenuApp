//
//  MenuViewController.swift
//  App
//
//  Created by Павел Кошара on 16/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import UIKit

private enum LayoutStyle {
    case grid
    case line
}

final class MenuViewController: UIViewController {
    @IBOutlet private weak var changeLayoutButton: UIButton!
    @IBOutlet private weak var menuCollectionView: UICollectionView!
    @IBOutlet private weak var menuCollectionViewLayout: TopAlignedCollectionViewLayout!
    @IBOutlet private weak var reloadButton: UIButton!

    var menuItemsProvider: MenuItemsProvider!

    private var didSetInitialLayout = false
    private var layoutStyle = LayoutStyle.line

    override func viewDidLoad() {
        super.viewDidLoad()

        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self

        changeLayoutButton.isHidden = UIDevice.current.isIphone

        menuItemsProvider.delegate = self
        menuItemsProvider.loadMetadata()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if !didSetInitialLayout {
            updateCollectionLayout()
            didSetInitialLayout = true
        }
    }

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)

        let firstVisibleItem = menuCollectionView.indexPathsForVisibleItems.sorted().first
        updateCollectionLayout()

        coordinator.animateAlongsideTransition(in: nil, animation: nil) { [weak self] _ in
            if let firstVisibleItem = firstVisibleItem, firstVisibleItem.item > 0 {
                self?.scrollMenu(toItemAtIndexPath: firstVisibleItem)
            }
        }
    }

    @IBAction private func layoutButtonTapInside(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Сетка", style: .default, handler: { [weak self] _ in
            self?.setLayoutStyle(to: .grid)
        }))

        alert.addAction(UIAlertAction(title: "По одному", style: .default, handler: { [weak self] _ in
            self?.setLayoutStyle(to: .line)
        }))

        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = changeLayoutButton
            popoverController.sourceRect = CGRect(
                x: changeLayoutButton.frame.width / 2,
                y: changeLayoutButton.frame.height,
                width: 0,
                height: 0
            )
        }

        present(alert, animated: true, completion: nil)
    }

    @IBAction func reloadButtonTapInside(_ sender: Any) {
        menuItemsProvider.loadMetadata()
        menuCollectionView.reloadData()
    }

    private func updateCollectionLayout() {
        let direction: UICollectionView.ScrollDirection
        if UIDevice.current.isPortraitOrientation || layoutStyle == .grid {
            direction = .vertical
        } else {
            direction = .horizontal
        }

        menuCollectionViewLayout.scrollDirection = direction
        menuCollectionViewLayout.invalidateLayout()
    }

    private func setLayoutStyle(to style: LayoutStyle) {
        let firstVisibleItem = menuCollectionView.indexPathsForVisibleItems.sorted().first

        layoutStyle = style
        updateCollectionLayout()
        menuCollectionView.reloadData()

        if let firstVisibleItem = firstVisibleItem, firstVisibleItem.item > 0 {
            scrollMenu(toItemAtIndexPath: firstVisibleItem)
        }
    }

    private func scrollMenu(toItemAtIndexPath indexPath: IndexPath) {
        let scrollPosition: UICollectionView.ScrollPosition
        if layoutStyle == .grid {
            scrollPosition = .top
        } else {
            scrollPosition = UIDevice.current.isPortraitOrientation ? .top : .left
        }

        menuCollectionView.scrollToItem(
            at: indexPath,
            at: scrollPosition,
            animated: false
        )
    }

    private func itemWidth() -> CGFloat {
        let device = UIDevice.current
        switch (device.isPortraitOrientation, device.isIphone, layoutStyle) {
        case (true, true, _), (true, false, .line):
            return menuCollectionView.frame.width * 0.7

        case (false, true, _), (false, false, .line):
            return menuCollectionView.frame.height * 0.6

        case (true, false, .grid):
            return menuCollectionView.frame.width * 0.3

        case (false, false, .grid):
            return menuCollectionView.frame.width * 0.22
        }
    }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard menuItemsProvider.status == .normal else {
            return menuCollectionViewLayout.sizeWithoutInsets
        }

        let width = itemWidth()
        guard let item = menuItemsProvider.viewModel(at: indexPath.item) else {
            return CGSize(width: width, height: width)
        }

        let height = MenuCollectionViewCell.height(for: item, width: width)

        return CGSize(width: width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        menuItemsProvider.loadPageForItem(at: indexPath.item)
    }
}

extension MenuViewController: MenuItemsProviderDelegate {
    func metadataLoaded() {
        assert(Thread.isMainThread)

        menuItemsProvider.loadPageForItem(at: 0)
        menuCollectionView.reloadData()
    }

    func itemsLoaded(from: Int, to: Int) {
        assert(Thread.isMainThread)

        guard menuItemsProvider.status == .normal else {
            return
        }

        let indexPaths = (from..<to).map {
            IndexPath(item: $0, section: 0)
        }

        menuCollectionView.reloadItems(at: indexPaths)
    }

    func imageLoaded(forItemAtIndex index: Int) {
        assert(Thread.isMainThread)

        guard menuItemsProvider.status == .normal else {
            return
        }

        menuCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }

    func errorOccured() {
        assert(Thread.isMainThread)

        menuCollectionView.reloadData()
    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch menuItemsProvider.status {
        case .uninitialized, .error:
            return 1
        case .normal:
            return menuItemsProvider.itemsCount ?? 1
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch menuItemsProvider.status {
        case .uninitialized:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "Loading", for: indexPath)
        case .error:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "Error", for: indexPath)
        case .normal:
            break
        }

        guard let item = menuItemsProvider.viewModel(at: indexPath.item) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "Loading", for: indexPath)
        }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MenuCollectionViewCell.identifier,
            for: indexPath
        )

        if let menuCell = cell as? MenuCollectionViewCell {
            menuCell.update(with: item)
        }

        return cell
    }
}
