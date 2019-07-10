//
//  UIColor+ColorPalette.swift
//  RickAndMorty
//
//  Created by Leonardo de Matos on 10/07/19.
//  Copyright © 2019 Leonardo de Matos. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static var rmLightGreen: UIColor = UIColor.with(red: 117, green: 253, blue: 48)
    static var rmDarkGreen: UIColor = UIColor.with(red: 57, green: 162, blue: 9)
    static var rmMediumGreen: UIColor = UIColor.with(red: 62, green: 205, blue: 12)
    
    static func with(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
