//
//  ContentCategoryCell.swift
//  MovieBrowsing
//
//  Created by Mubin Khan on 8/30/23.
//

import UIKit

class ContentCategoryCell: UICollectionViewCell {

    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    
    let colors = [UIColor(red: 1, green: 0.56, blue: 0.44, alpha: 1), UIColor(red: 0.94, green: 0.18, blue: 0.1, alpha: 1)]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        barView.applyGradient(colors: colors, startPoint: CGPoint(x: -0.5, y: 1), endPoint: CGPoint(x: -0.5, y: 1))
    }

}

extension UIView {
    func applyGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds

        layer.insertSublayer(gradientLayer, at: 0)
    }
}


