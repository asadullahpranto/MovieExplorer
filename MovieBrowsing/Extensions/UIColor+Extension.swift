//
//  UIColor+Extension.swift
//  MovieBrowsing
//
//  Created by Mubin Khan on 8/30/23.
//

import Foundation
import UIKit

public extension UIColor {
    
    static func fromGradient(_ gradient: GradientLayer, frame: CGRect, cornerRadius: CGFloat = 0) -> UIColor? {
        guard let image = UIImage.fromGradient(gradient, frame: frame, cornerRadius: cornerRadius) else { return nil }
        
        return UIColor(patternImage: image)
    }
    
    static func fromGradientWithDirection(_ direction: GradientDirection, frame: CGRect, colors: [UIColor], cornerRadius: CGFloat = 0, locations: [Double]? = nil) -> UIColor? {
        let gradient = GradientLayer(direction: direction, colors: colors, cornerRadius: cornerRadius, locations: locations)
        return UIColor.fromGradient(gradient, frame: frame)
    }
}

public extension UIImage {
    
    static func fromGradient(_ gradient: GradientLayer, frame: CGRect, cornerRadius: CGFloat = 0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        let cloneGradient = gradient.clone()
        cloneGradient.frame = frame
        cloneGradient.cornerRadius = cornerRadius
        cloneGradient.render(in: ctx)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
    static func fromGradientWithDirection(_ direction: GradientDirection, frame: CGRect, colors: [UIColor], cornerRadius: CGFloat = 0, locations: [Double]? = nil) -> UIImage? {
        let gradient = GradientLayer(direction: direction, colors: colors, cornerRadius: cornerRadius, locations: locations)
        return UIImage.fromGradient(gradient, frame: frame)
    }

}

