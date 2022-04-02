//
//  ReactionCollectionViewCell.swift
//  Telie
//
//  Created by Haiying W on 3/15/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class BlurredTextView: UITextView {

    func blur(_ blurRadius: Double = 2) {
        let blurredImage = getBlurryImage(blurRadius)
        let blurredImageView = UIImageView(image: blurredImage)
        blurredImageView.translatesAutoresizingMaskIntoConstraints = false
        blurredImageView.tag = 100
        blurredImageView.contentMode = .center
        blurredImageView.backgroundColor = .white
        addSubview(blurredImageView)
        NSLayoutConstraint.activate([
            blurredImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurredImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func unblur() {
        subviews.forEach { subview in
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
    }

    private func getBlurryImage(_ blurRadius: Double = 2) -> UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
            let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()

        blurFilter.setDefaults()

        blurFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)

        var convertedImage: UIImage?
        let context = CIContext(options: nil)
        if let blurOutputImage = blurFilter.outputImage,
            let cgImage = context.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
            convertedImage = UIImage(cgImage: cgImage)
        }

        return convertedImage
    }
}

class ReactionCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let containerView = UIView()
    private let reactionTextView = BlurredTextView()
    private let profileImageView = UIImageView()

    static let cellReuseIdentitifer = "ReactionCollectionViewCellReuseIdentifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.isUserInteractionEnabled = true
        backgroundColor = .offWhite

        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.layer.backgroundColor = UIColor.white.cgColor
        containerView.isUserInteractionEnabled = true
        contentView.addSubview(containerView)

        reactionTextView.font = .systemFont(ofSize: 12)
        reactionTextView.isEditable = false
        reactionTextView.isScrollEnabled = false
        reactionTextView.isUserInteractionEnabled = false
        containerView.addSubview(reactionTextView)

        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        contentView.addSubview(profileImageView)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        reactionTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(containerView.snp.bottom).inset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(reaction: Reaction) {
        reactionTextView.text = reaction.text
        reactionTextView.layoutIfNeeded()
        reactionTextView.blur()
        if let imageUrl = URL(string: reaction.author.profilePicUrl ?? Constants.User.defaultImage) {
            profileImageView.kf.setImage(with: imageUrl)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
}
