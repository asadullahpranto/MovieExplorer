//
//  DetailsViewController.swift
//  MovieBrowsing
//
//  Created by Mubin Khan on 8/31/23.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContainerView()
    }
    
    func setupContainerView() {
        let view = DetailsView(frame: .zero)
        view.frame = containerView.bounds
        containerView.addSubview(view)
    }

}
