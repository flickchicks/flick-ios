//
//  RatingSliderControl.swift
//  Flick
//
//  Created by Lucy Xu on 7/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class SliderControlTrackLayer: CALayer {
    weak var ratingsSliderControl: RatingSliderControl?

    override func draw(in context: CGContext) {
        guard let slider = ratingsSliderControl else {
            return
        }

        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 4)
        context.addPath(path.cgPath)

        // Fill in color for the entire bar
        context.setFillColor(slider.trackTintColor.cgColor)
        context.fillPath()

        // Fill in color between bar origin and highest rating
        context.setFillColor(slider.trackHighlightTintColor.cgColor)
        let personalValuePosition = slider.positionForValue(slider.personalValue)
        let externalValuePosition = slider.positionForValue(slider.externalValue)
        let maxValuePosition = max(personalValuePosition, externalValuePosition)
        let rect = CGRect(x: 0, y: 0, width: maxValuePosition, height: bounds.height)
        context.fill(rect)
    }
}

enum RatingsSliderType { case friends, reviewers }

class RatingSliderControl: UIControl {

    // MARK: - Private View Vars
    private let externalThumbImageView = UIImageView()
    private let personalThumbImageView = UIImageView()
    private let ratingLabel = UILabel()
    private let trackLayer = SliderControlTrackLayer()

    // MARK: - Private Data Vars
    private let iconSize = CGSize(width: 14, height: 14)
    private let minimumValue: CGFloat = 0
    private let maximumValue: CGFloat = 1
    private var previousLocation = CGPoint()
    private let personalIconSize = CGSize(width: 20, height: 20)

    // MARK: - Public Data Vars

    override var frame: CGRect {
        // Property observer to update layer frame when frame changes
        // Used when control is initialized with a frame that's not final frame
        didSet {
            updateLayerFrames()
        }
    }

    var personalValue: CGFloat = 0 {
        didSet {
            updateLayerFrames()
        }
    }

    var externalValue: CGFloat = 0.6 {
        didSet {
            updateLayerFrames()
        }
    }

    let trackTintColor: UIColor = .lightGray2
    // TODO: Change tint color to gradient
    let trackHighlightTintColor: UIColor = .gradientPurple

    init(type: RatingsSliderType) {
        super.init(frame: .zero)

        trackLayer.ratingsSliderControl = self
        trackLayer.contentsScale = UIScreen.main.scale
        trackLayer.setNeedsDisplay()
        layer.addSublayer(trackLayer)

        ratingLabel.layer.backgroundColor = UIColor.lightPurple.cgColor
        ratingLabel.layer.cornerRadius = 4
        ratingLabel.textAlignment = .center
        ratingLabel.textColor = .gradientPurple
        ratingLabel.font = .systemFont(ofSize: 10)
        addSubview(ratingLabel)

        switch type {
        case .friends:
            personalThumbImageView.image = UIImage(named: "dunkirk") // TODO: Replace with user icon image
            personalThumbImageView.layer.masksToBounds = true
            personalThumbImageView.clipsToBounds = true
            personalThumbImageView.layer.borderColor = UIColor.gradientPurple.cgColor
            personalThumbImageView.layer.borderWidth = 1
            externalThumbImageView.image = UIImage(named: "friendIcon")
            ratingLabel.text = "Friends"
        case .reviewers:
            externalThumbImageView.image = UIImage(named: "star")
            ratingLabel.text = "Critics"
        }

        personalThumbImageView.layer.cornerRadius = 10
        addSubview(personalThumbImageView)

        addSubview(externalThumbImageView)

        updateLayerFrames()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

    // Set frames for views to see the elements
    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3) // Center the track layer
        trackLayer.setNeedsDisplay()
        let personalThumbOrigin = thumbOriginForValue(value: personalValue, image: personalThumbImageView)
        let externalThumbOrigin = thumbOriginForValue(value: externalValue, image: externalThumbImageView)
        personalThumbImageView.frame = CGRect(origin: personalThumbOrigin, size: personalIconSize)
        externalThumbImageView.frame = CGRect(origin: externalThumbOrigin, size: iconSize)
        // x offset calculculated from (labelWidth / 2) + (externalThumbIcon.width / 2)
        // y offset calculated from verticalOffset + (labeHeight / 2) + (barHeight / 2)
        ratingLabel.frame = CGRect(x: externalThumbOrigin.x - 16, y: externalThumbOrigin.y - 28, width: 46, height: 20)
        CATransaction.commit()
    }

    func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
    }

    private func thumbOriginForValue(value: CGFloat, image: UIImageView) -> CGPoint {
        let imageWidth = image.frame.width
        let x = positionForValue(value) - (imageWidth / 2.0)
        return CGPoint(x: x, y: (bounds.height - imageWidth) / 2.0)
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = deltaLocation / bounds.width
        previousLocation = location
        personalValue += deltaValue
        personalValue = boundValue(personalValue, toLowerValue: minimumValue, upperValue: maximumValue)
        sendActions(for: .valueChanged)
        return true
    }

    /// Keeps rating icon within range
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
}
