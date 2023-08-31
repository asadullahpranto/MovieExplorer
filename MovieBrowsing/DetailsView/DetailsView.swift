//
//  DetailsView.swift
//  MovieBrowsing
//
//  Created by Mubin Khan on 8/29/23.
//

import UIKit

class DetailsView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var symposisLabel: UILabel!
    @IBOutlet weak var reletedMoieCollection: UICollectionView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var rationgLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    private var currentPage = 1
    private var discoverEndpoing = "movie"
    var movieID = ""
    
    
    private var reuseId = "ContentViewCell"
    
    
    var reletedMovie: DiscoverResponse?
    private var _reletedMovie: DiscoverResponse? {
        didSet {
            if reletedMovie == nil {
                reletedMovie = _reletedMovie
                return
            }
            reletedMovie?.results?.append(contentsOf: (_reletedMovie?.results)!)
    
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    func commonInit() {
        containerView = loadViewFromNib()
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(containerView)
        
        reletedMoieCollection.dataSource = self
        reletedMoieCollection.delegate = self
        
        reletedMoieCollection.register(UINib(nibName: reuseId, bundle: nil), forCellWithReuseIdentifier: reuseId)
        
        requestToMovieDB()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    func requestToMovieDB() {
        ApiManager.shared.fetchData(endPoint: discoverEndpoing, movieID: movieID, currentPage: currentPage, completion: { [self](result: Result<DiscoverResponse, Error>) in
            
            switch result {
            case .success(let data):
                _reletedMovie = data
                print(data)
                
                DispatchQueue.main.async {
                    self.reletedMoieCollection.reloadData()
                    if self.currentPage == 1 {
                        if let data = self.reletedMovie?.results, !data.isEmpty {
                            self.reletedMoieCollection?.setContentOffset(.zero, animated: false)
                        }
                    }
                }
                
                currentPage += 1
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reletedMovie?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! ContentViewCell
        
        if let data = reletedMovie?.results?[indexPath.item] {
            cell.movieTitle.text = data.originalTitle
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastItemIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        
        // Check if the current indexPath is close to the last item in the collection view
        if indexPath.section == lastSectionIndex && indexPath.item == lastItemIndex {
            // Load the next page
            loadNextPage()
        }
    }
    
    func loadNextPage() {
        
        requestToMovieDB()
    }

}
