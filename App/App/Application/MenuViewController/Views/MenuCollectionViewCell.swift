//
//  MenuCollectionViewCell.swift
//  App
//
//  Created by Павел Кошара on 16/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import UIKit

final class MenuCollectionViewCell: UICollectionViewCell {
    static let identifier = "MenuItem"

    private var imageView: UIImageView!
    private var nameLabel: UILabel!
    private var priceLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        createSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        createSubviews()
    }

    static func height(for menuItem: MenuItemViewModel, width: CGFloat) -> CGFloat {
        let priceSize = textSize(for: menuItem.price, font: priceFont)

        let nameHeight = textSize(
            for: menuItem.name,
            font: nameFont,
            maxWidth: width - priceSize.width - nameAndPriceSpacing
        ).height

        return width + imageAndTextSpacing + max(nameHeight, priceSize.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)

        priceLabel.sizeToFit()
        priceLabel.frame.origin = CGPoint(
            x: frame.width - priceLabel.frame.width,
            y: frame.width + imageAndTextSpacing
        )

        let nameWidth = frame.width - priceLabel.frame.width - nameAndPriceSpacing
        let nameSize = nameLabel.sizeThatFits(CGSize(width: nameWidth, height: .greatestFiniteMagnitude))
        nameLabel.frame = CGRect(
            origin: CGPoint(x: 0, y: frame.width + imageAndTextSpacing),
            size: nameSize
        )
    }

    func update(with menuItem: MenuItemViewModel) {
        nameLabel.text = menuItem.name
        priceLabel.text = menuItem.price

        if let image = menuItem.image {
            imageView.stopAnimating()
            imageView.animationImages = nil
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
        } else {
            imageView.contentMode = .center
            imageView.animationImages = Constants.spinnerImages
            imageView.animationDuration = 1
            imageView.startAnimating()
        }

        setNeedsLayout()
    }

    private func createSubviews() {
        imageView = UIImageView()

        nameLabel = UILabel()
        nameLabel.font = nameFont
        nameLabel.numberOfLines = 0

        priceLabel = UILabel()
        priceLabel.font = priceFont

        [imageView, nameLabel, priceLabel].forEach(contentView.addSubview)
    }
}

private func textSize(for text: String, font: UIFont, maxWidth: CGFloat? = nil) -> CGSize {
    let size = (text as NSString).boundingRect(
        with: CGSize(width: maxWidth ?? CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude),
        options: .usesLineFragmentOrigin,
        attributes: [.font: font],
        context: nil
    ).size

    return CGSize(width: ceil(size.width), height: ceil(size.height))
}

private let priceFont = UIFont.systemFont(ofSize: 21, weight: .semibold)
private let nameFont = UIFont.systemFont(ofSize: 15)
private let nameAndPriceSpacing: CGFloat = 8
private let imageAndTextSpacing: CGFloat = 8
