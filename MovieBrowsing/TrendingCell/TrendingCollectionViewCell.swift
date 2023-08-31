//
//  TrendingCollectionViewCell.swift
//  MovieBrowsing
//
//  Created by Mubin Khan on 8/29/23.
//

import UIKit
import FSPagerView

class TrendingCollectionViewCell: FSPagerViewCell {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var ratingContainerView: UIView!
    
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let layer0 = CAGradientLayer()
        layer0.colors = [
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor,
        UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        ]
        layer0.locations = [0, 0.42, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        layer0.bounds = posterView.bounds.insetBy(dx: -0.5*posterView.bounds.size.width, dy: -0.5*posterView.bounds.size.height)
        layer0.position = posterView.center
        posterView.layer.addSublayer(layer0)
        
        posterView.layer.cornerRadius = 30
        posterView.clipsToBounds = true
        
        ratingContainerView.layer.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 0.3).cgColor
        ratingContainerView.layer.cornerRadius = 15
        ratingContainerView.clipsToBounds = true
        
        titleContainerView.layer.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 0.3).cgColor
        titleContainerView.layer.cornerRadius = 20
        titleContainerView.clipsToBounds = true
        titleContainerView.layer.borderWidth = 1
        
        let layer = GradientLayer(direction: .bottomRightToTopLeft, colors: [UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.0), UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.3)])
        
        titleContainerView.layer.borderColor = UIColor.fromGradient(layer, frame: titleContainerView.bounds)?.cgColor
        
        
        
        titleContainerView.layer.borderColor = UIColor.fromGradient(layer, frame: titleContainerView.bounds)?.cgColor
        
        ratingContainerView.layer.cornerRadius = 15
        ratingContainerView.layer.borderWidth = 1
        ratingContainerView.layer.borderColor = UIColor.fromGradient(layer, frame: ratingsLabel.bounds)?.cgColor
        ratingContainerView.clipsToBounds = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        
    }

}
