//
//  UIColor+extension.swift
//  KAVAudioRecorderDemo_Swift
//
//  Created by 孔雨露 on 2020/2/2.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

extension UIColor {
    func lighterColor() -> UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: min(brightness * CGFloat(1.3), CGFloat(1.0)), alpha: alpha)
        }
        return self
    }

    func darkerColor() -> UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * CGFloat(0.92), alpha: alpha)
        }
        return self
    }
}
