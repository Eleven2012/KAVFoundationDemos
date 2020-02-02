//
//  KControl.swift
//  KAVAudioRecorderDemo_Swift
//
//  Created by 孔雨露 on 2020/2/2.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

@IBDesignable
class KControl: UIControl {

    private let MAX_ANGLE = 120.0
    private let SCALING_FACTOR = 4.0

    private var _value = 0.0

    private var animated = true
    private var angle = 0.0
    private var indicatorView: KIndicator!
    private var touchOrigin = CGPoint.zero

    @IBInspectable var minimumValue:Double = -1.0
    @IBInspectable var maximumValue:Double = 1.0
    @IBInspectable var defaultValue:Double = 0.0
    @IBInspectable var value: Double {
        get {
            return _value
        }
        set {
            setValue(newValue, animated: false)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {
        self.backgroundColor = UIColor.clear

        indicatorView = KIndicator(frame: bounds)
        indicatorView.lightColor = indicatorLightColor()
        addSubview(indicatorView)

        self.valueDidChangeFrom(defaultValue, toValue: defaultValue, animated: false)
    }

    func indicatorLightColor() -> UIColor {
        return UIColor.white
    }

    func clampAngle(_ angle: Double) -> Double {
        if angle < -MAX_ANGLE {
            return -MAX_ANGLE
        } else if angle > MAX_ANGLE {
            return MAX_ANGLE
        }
        return angle
    }

    func angleForValue(_ value: Double) -> Double {
        return ((value - minimumValue) / (maximumValue - minimumValue) - 0.5) * (MAX_ANGLE * 2.0)
    }

    func valueForAngle(_ angle: Double) -> Double {
        return (angle / (MAX_ANGLE * 2.0) + 0.5) * (maximumValue - minimumValue) + minimumValue
    }

    func valueForPosition(_ point: CGPoint) -> Double {
        let delta = Double(touchOrigin.y - point.y)
        let newAngle = clampAngle(delta * SCALING_FACTOR + angle)
        let newValue = valueForAngle(newAngle)
        return newValue
    }

    func setValue(_ newValue: Double, animated: Bool) {
        let oldValue = self.value
        if newValue < minimumValue {
            _value = minimumValue
        } else if newValue > maximumValue {
            _value = maximumValue
        } else {
            _value = newValue
        }
        valueDidChangeFrom(oldValue, toValue: _value, animated: animated)
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        touchOrigin = point
        angle = angleForValue(self.value)
        isHighlighted = true
        setNeedsDisplay()
        return true
    }

    func handleTouch(_ touch: UITouch) -> Bool {
        if touch.tapCount > 1 {
            setValue(defaultValue, animated: true)
            return false
        }
        let point = touch.location(in: self)
        self.value = valueForPosition(point)
        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if handleTouch(touch) {
            sendActions(for: .valueChanged)
        }
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if let touch = touch {
            if handleTouch(touch) {
                sendActions(for: .valueChanged)
            }
        }
        isHighlighted = false
        setNeedsDisplay()
    }

    override func prepareForInterfaceBuilder() {
        setNeedsDisplay()
        setupView()
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        // Set up Colors
        let strokeColor = UIColor(white: 0.04, alpha: 1.0)
        var gradientLightColor = UIColor(white: 0.150, alpha: 1.0)
        var gradientDarkColor = UIColor(white: 0.210, alpha: 1.0)

        if isHighlighted {
            gradientLightColor = gradientLightColor.darkerColor().darkerColor()
            gradientDarkColor = gradientDarkColor.darkerColor().darkerColor()
        }

        let gradientColors = [gradientLightColor.cgColor, gradientDarkColor.cgColor]
        let locations = [CGFloat(0.0), CGFloat(1.0)]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: locations)

        let insetRect = rect.insetBy(dx: 0.5, dy: 0.5)

        // Draw Bezel
        context.setFillColor(strokeColor.cgColor)
        context.fillEllipse(in: insetRect)

        let midX = insetRect.midX
        let midY = insetRect.midY

        context.addArc(center: CGPoint(x: midX, y: midY), radius: insetRect.width / 2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        context.setShadow(offset: CGSize(width: 0.0, height: 0.5), blur: 2.0, color: UIColor.darkGray.cgColor)
        context.fillPath()

        // Add Clipping Region for Knob Background
        context.addArc(center: CGPoint(x: midX, y: midY), radius: (insetRect.width - 6) / 2, startAngle: 0, endAngle:  .pi * 2, clockwise: true)
        context.clip()

        let startPoint = CGPoint(x: midX, y: insetRect.maxY)
        let endPoint = CGPoint(x: midX, y: insetRect.minY)
        
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
    }

    func valueDidChangeFrom(_ fromValue: Double, toValue: Double, animated: Bool) {

        let newAngle = angleForValue(toValue)

        if animated {
            let oldAngle = angleForValue(fromValue)
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.duration = 0.2
            animation.values = [
                oldAngle * .pi / 180.0,
                (newAngle + oldAngle) / 2.0 * .pi / 180.0,
                newAngle * .pi / 180.0
            ]
            animation.keyTimes = [0.0, 0.5, 1.0]
            animation.timingFunctions = [
                CAMediaTimingFunction(name: .easeIn),
                CAMediaTimingFunction(name: .easeOut)
            ]
            indicatorView.layer.add(animation, forKey: nil)
        }

        indicatorView.transform = CGAffineTransform(rotationAngle: CGFloat(newAngle * .pi / 180.0))
    }
}

class KGreenControl: KControl {
    override func indicatorLightColor() -> UIColor {
        return UIColor(red: 0.226, green: 1.0, blue: 0.226, alpha: 1.0)
    }
}

class KOrangeControl: KControl {
    override func indicatorLightColor() -> UIColor {
        return UIColor(red: 1.0, green: 0.718, blue: 0.0, alpha: 1.0)
    }
}

