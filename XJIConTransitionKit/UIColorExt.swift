//
//  UIColorExt.swift
//  XJShapedButton
//
//  Created by 万旭杰 on 16/6/21.
//  Copyright © 2016年 万旭杰. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

extension UIColor {
    
    func initWithRGBValue(rgb: UInt32) -> UIColor! {
        let red: CGFloat = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green: CGFloat = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue: CGFloat = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func initWithRGBAValue(rgb: UInt32) -> UIColor! {
        let red: CGFloat = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
        let green: CGFloat = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
        let blue: CGFloat = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
        let alpha: CGFloat = CGFloat(rgb & 0x000000FF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func initWithRGBValueWithAlpha(rgb: UInt32, alpha: CGFloat) -> UIColor! {
        let red: CGFloat = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green: CGFloat = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue: CGFloat = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func colorWithRGBValue(rgb: UInt32) -> UIColor! {
        return UIColor().initWithRGBValue(rgb)
    }
    
    class func colorWithRGBAValue(rgba: UInt32) -> UIColor! {
        return UIColor().initWithRGBAValue(rgba)
    }
    
    class func colorWithRGBValueWithAlpha(rgb: UInt32, alpha: CGFloat) -> UIColor! {
        return UIColor().initWithRGBValueWithAlpha(rgb, alpha: alpha)
    }
    
    //MARK: CustomColor
    class func customGrayColor() -> UIColor {
        return self.colorWithRed(84, green: 84, blue: 84)
    }
    
    class func customRedColor() -> UIColor {
        return self.colorWithRed(231, green: 76, blue: 60)
    }   
    
    class func customYellowColor() -> UIColor {
        return self.colorWithRed(241, green: 196, blue: 15)
    }
    
    class func customGreenColor() -> UIColor {
        return self.colorWithRed(46, green: 204, blue: 113)
    }
    
    class func customBlueColor() -> UIColor {
        return self.colorWithRed(52, green: 152, blue: 219)
    }
    
    class func colorWithRed(red: Int, green: Int, blue: Int) -> UIColor {
        let red: CGFloat = CGFloat(red) / 255.0
        let green: CGFloat = CGFloat(green) / 255.0
        let blue: CGFloat = CGFloat(blue) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
