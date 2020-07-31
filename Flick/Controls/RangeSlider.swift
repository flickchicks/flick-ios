//
//  RatingSliderControl.swift
//  Flick
//
//  Created by Lucy Xu on 7/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class RangeSliderTrackLayer: CALayer {
  weak var rangeSlider: RangeSlider?

  override func draw(in context: CGContext) {
    guard let slider = rangeSlider else {
      return
    }

    let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    context.addPath(path.cgPath)

    context.setFillColor(slider.trackTintColor.cgColor)
    context.fillPath()

    context.setFillColor(slider.trackHighlightTintColor.cgColor)

    // Fill in color between bar origin and highest rating
    let personalValuePosition = slider.positionForValue(slider.personalValue)
    let externalValuePosition = slider.positionForValue(slider.externalValue)
    let maxValuePosition = max(personalValuePosition, externalValuePosition)
    let rect = CGRect(x: 0, y: 0, width: maxValuePosition, height: bounds.height)
    context.fill(rect)
  }
}

class RangeSlider: UIControl {

    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }

    var minimumValue: CGFloat = 0 {
        didSet {
            updateLayerFrames()
        }
    }

    var maximumValue: CGFloat = 1 {
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

    var trackTintColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    var trackHighlightTintColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    var personalThumbImage = UIImage(named: "movie") {
        didSet {
            externalThumbImageView.image = personalThumbImage
            personalThumbImageView.image = personalThumbImage
            updateLayerFrames()
        }
    }

    private let trackLayer = RangeSliderTrackLayer()
    private let personalThumbImageView = UIImageView()
    private let externalThumbImageView = UIImageView()
    private var previousLocation = CGPoint()

    override init(frame: CGRect) {
        super.init(frame: frame)

        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)

        personalThumbImageView.image = personalThumbImage
        personalThumbImageView.layer.cornerRadius = 6
        personalThumbImageView.layer.borderColor = UIColor.gradientPurple.cgColor
        personalThumbImageView.layer.borderWidth = 1
        addSubview(personalThumbImageView)

        externalThumbImageView.image = UIImage(named: "star")
        addSubview(externalThumbImageView)
  }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        personalThumbImageView.frame = CGRect(origin: thumbOriginForValue(personalValue), size: CGSize(width: 14, height: 14))
        externalThumbImageView.frame = CGRect(origin: thumbOriginForValue(externalValue), size:CGSize(width: 14, height: 14))
        CATransaction.commit()
    }

    func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
    }

    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let x = positionForValue(value) - 14 / 2.0
        return CGPoint(x: x, y: (bounds.height - 14.0) / 2.0)
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {

        previousLocation = touch.location(in: self)

        if personalThumbImageView.frame.contains(previousLocation) {
            personalThumbImageView.isHighlighted = true
        }

        return personalThumbImageView.isHighlighted
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width

        previousLocation = location

        if personalThumbImageView.isHighlighted {
            personalValue += deltaValue
            personalValue = boundValue(personalValue, toLowerValue: minimumValue, upperValue: maximumValue)
        }
        sendActions(for: .valueChanged)
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        personalThumbImageView.isHighlighted = false
    }

    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
}
