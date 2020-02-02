//
//  KIndicator.swift
//  KAVAudioRecorderDemo_Swift
//
//  Created by 孔雨露 on 2020/2/2.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class KIndicator: UIView {

    var lightColor = UIColor.white {
        didSet {
            setNeedsDisplay()
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
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();

        let midX = rect.midX
        let minY = rect.minY
        let width = rect.width * 0.15
        let height = rect.height * 0.15
        let indicatorRect = CGRect(x: midX - (width / 2), y: minY + 15, width: width, height: height)

        let strokeColor = lightColor.darkerColor()
        context?.setStrokeColor(strokeColor.cgColor)
        context?.setFillColor(self.lightColor.cgColor)

        let shadowColor = lightColor.lighterColor()
        let shadowOffset = CGSize(width: 0.0, height: 0.0)
        let blurRadius = CGFloat(2.0)

        context?.setShadow(offset: shadowOffset, blur: blurRadius, color: shadowColor.cgColor)

        context?.addEllipse(in: indicatorRect)
        context?.drawPath(using: .fillStroke)
    }
}

