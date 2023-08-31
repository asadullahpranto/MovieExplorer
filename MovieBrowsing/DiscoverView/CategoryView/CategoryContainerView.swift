//
//  CategoryContainerView.swift
//  MovieBrowsing
//
//  Created by Mubin Khan on 8/30/23.
//

import UIKit

protocol CategorySelectionDelegate: AnyObject {
    func selectedCategory(categoryIndex: Int)
}

class CategoryContainerView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    weak var delegate: CategorySelectionDelegate?
    
    let colors = [ UIColor(red: 0.94, green: 0.18, blue: 0.1, alpha: 1), UIColor(red: 1, green: 0.56, blue: 0.44, alpha: 1)]
    
    private var selectedIndex = 0
    
    let allCategory: [String] = [
        "Movies", "Tv Series", "Documentary", "Sports"
    ]
    
    private let resueID = "ContentCategoryCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
        
    }
    
    private func commonInit() {
        containerView = loadViewFromNib()
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(containerView)
        
        categoryCollection.delegate = self
        categoryCollection.dataSource  = self
        categoryCollection.register(UINib(nibName: resueID, bundle: nil), forCellWithReuseIdentifier: resueID)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resueID, for: indexPath) as! ContentCategoryCell
        
        cell.categoryTitle.text = allCategory[indexPath.item]
        
        if selectedIndex == indexPath.item {
            cell.barView.isHidden = false
            
        } else {
            cell.barView.isHidden = true
        }
        
        if indexPath.item == 0 {
            let layer = GradientLayer(direction: .leftToRight, colors: colors)
            cell.categoryTitle.textColor = UIColor.fromGradient(layer, frame: cell.categoryTitle.bounds)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = allCategory[indexPath.item]
        var rect: CGRect = .zero
        rect.size = label.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Lato-Regular" , size: 16)])
        
        return CGSize(width: rect.width, height: categoryCollection.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let preCell = collectionView.cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as! ContentCategoryCell
        preCell.barView.isHidden = true
        preCell.categoryTitle.textColor = UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)
        
        let cell = collectionView.cellForItem(at: indexPath) as! ContentCategoryCell
        cell.barView.isHidden = false
        let layer = GradientLayer(direction: .leftToRight, colors: colors)
        cell.categoryTitle.textColor = UIColor.fromGradient(layer, frame: cell.categoryTitle.bounds)
        
        selectedIndex = indexPath.item
        
        delegate?.selectedCategory(categoryIndex: selectedIndex)
    }
    
}
