//
//  UIColor+Hex.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/21.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

let defaultBackgroundColor = UIColor(hex: "2D3250")
let defaultTextColor = UIColor(hex: "EEE2DE")

let midBlue = UIColor(hex: "424769")
let lightBlue = UIColor(hex: "7077A1")
let midOrange = UIColor(hex: "F6B17A")
let newBrown = UIColor(hex: "481E14")
let brick = UIColor(hex: "9B3922")
let lightRed = UIColor(hex: "F2613F")
