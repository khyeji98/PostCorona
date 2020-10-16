//
//  UIExtensions.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/10.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum FontType {
        case regular, medium, bold, light
    }
    
    static func NotoSansKR (type: FontType, size: CGFloat) -> UIFont {
        switch type {
        case .bold:
            return UIFont(name: "NotoSansKR-Bold", size: size)!
        case .medium:
            return UIFont(name: "NotoSansKR-Medium", size: size)!
        case .regular:
            return UIFont(name: "NotoSansKR-Regular", size: size)!
        case .light:
            return UIFont(name: "NotoSansKR-Light", size: size)!
        }
    }
    
    static func AppleSDGothicNeo (type: FontType, size: CGFloat) -> UIFont {
        switch type {
        case .bold:
            return UIFont(name: "AppleSDGothicNeo-Bold", size: size)!
        case .medium:
            return UIFont(name: "AppleSDGothicNeo-Medium", size: size)!
        case .regular:
            return UIFont(name: "AppleSDGothicNeo-Regular", size: size)!
        case .light:
            return UIFont(name: "AppleSDGothicNeo-Light", size: size)!
        }
    }
    
    static func SFPro (type: FontType, size: CGFloat) -> UIFont {
        switch type {
        case .bold:
            return UIFont(name: "SFPro-Bold", size: size)!
        case .medium:
            return UIFont(name: "SFPro-Medium", size: size)!
        case .regular:
            return UIFont(name: "SFPro-Regular", size: size)!
        case .light:
            return UIFont(name: "SFPro-Light", size: size)!
        }
    }

}

extension UIColor {

    @nonobjc class var battleshipGrey: UIColor {
        return UIColor(red: 109.0 / 255.0, green: 114.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var lightBlack: UIColor {
        return UIColor(white: 51.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var brownGrey: UIColor {
        return UIColor(white: 162.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var clearBlue: UIColor {
        return UIColor(red: 52.0 / 255.0, green: 109.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var veryLightPink: UIColor {
        return UIColor(white: 204.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var darkBlack: UIColor {
      return UIColor(red: 39.0 / 255.0, green: 34.0 / 255.0, blue: 30.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var lightBrownGrey: UIColor {
      return UIColor(white: 170.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var deepSkyBlue: UIColor {
       return UIColor(red: 18.0 / 255.0, green: 120.0 / 255.0, blue: 1.0, alpha: 1.0)
     }
    
    @nonobjc class var dustyOrange: UIColor {
      return UIColor(red: 253.0 / 255.0, green: 99.0 / 255.0, blue: 44.0 / 255.0, alpha: 1.0)
    }

}
