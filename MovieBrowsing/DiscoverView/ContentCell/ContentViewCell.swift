//
//  ContentViewCell.swift
//  MovieBrowsing
//
//  Created by Mubin Khan on 8/30/23.
//

import UIKit

class ContentViewCell: UICollectionViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.cornerRadius = 20
        clipsToBounds = true
    }

}
