//
//  ViewController.swift
//  MovieBrowsing
//
//  Created by Mubin Khan on 8/28/23.
//

import UIKit
import Foundation
import FSPagerView
import Kingfisher

class ViewController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate {
    
    @IBOutlet weak var detailsContainer: UIView!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var groupIcon: UIImageView!
    @IBOutlet weak var playIcon: UIImageView!
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var pageContainer: UIView!
    @IBOutlet weak var groupBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var discoverBtn: UIButton!
    
    @IBOutlet weak var streamTitle: UILabel!
    @IBOutlet weak var playContainerView: UIView!
    
    @IBOutlet weak var trendingCollection: FSPagerView!
    
    var currentPage = 1
    var trendintEndpoint = "/trending/all/week"
    var noPlayingEndpoint = "/movie/now_playing"
    
    let baseURL = "https://api.themoviedb.org/3/movie/now_playing"
    
    var trendingData: Movies?
    private var _trendingData: Movies? {
        didSet {
            if trendingData == nil {
                trendingData = _trendingData
                return
            }
            trendingData?.results?.append(contentsOf: (_trendingData?.results!)!)
    
        }
    }
    
    var nowPlayingData: DiscoverResponse?
    
    let reuseID = "TrendingCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        streamTitle.text = "Stream Everywhere"

        configureViews()
        
        requestToMovieDB()
        
        requestForNowPlaying()
        
        self.trendingCollection.transformer = FSPagerViewTransformer(type: .linear)
        let transform = CGAffineTransform(scaleX: 0.65, y: 1)
        self.trendingCollection.itemSize = self.trendingCollection.frame.size.applying(transform)
        self.trendingCollection.decelerationDistance = FSPagerView.automaticDistance
        
        let layer0 = CAGradientLayer()
        layer0.colors = [
        UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        layer0.position = posterView.center
        posterView.layer.addSublayer(layer0)
        posterView.layer.cornerRadius = 30

        
        playContainerView.layer.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 0.3).cgColor
        playContainerView.layer.cornerRadius = 20
        playContainerView.layer.borderWidth = 1
        
        let layer = GradientLayer(direction: .bottomRightToTopLeft, colors: [UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.0), UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.3)])
        playContainerView.clipsToBounds = true
        playContainerView.layer.borderColor = UIColor.fromGradient(layer, frame: playContainerView.bounds)?.cgColor
        
        toolBarView.layer.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1).cgColor
        
        pageContainer.layer.backgroundColor = UIColor(red: 0.084, green: 0.078, blue: 0.121, alpha: 1).cgColor
        
        gotoHomePage(homeBtn)
    }
    
    
    func requestToMovieDB() {
        ApiManager.shared.fetchData(endPoint: trendintEndpoint, currentPage: currentPage, completion: { [self](result: Result<Movies, Error>) in
            
            switch result {
            case .success(let data):
                _trendingData = data
                print(data)
                
                currentPage += 1
                DispatchQueue.main.async {
                    self.trendingCollection.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func requestForNowPlaying() {
        ApiManager.shared.fetchData(endPoint: noPlayingEndpoint, currentPage: 1, completion: { [self](result: Result<DiscoverResponse, Error>) in
            
            switch result {
            case .success(let data):
                nowPlayingData = data
                print(data)
                if let nowPlaying = nowPlayingData?.results?[0].posterPath {
                    
                    if let url = URL(string: "https://image.tmdb.org/t/p/w500\(nowPlaying)") {
                        downloadImage(url: url)
                    }
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func downloadImage(url: URL) {
        // image does not available in cache.. so retrieving it from url...
       URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

           DispatchQueue.main.async(execute: { [self] in

               guard let unwrappedData = data, let image = UIImage(data: unwrappedData) else {
                   return
               }
               
               posterView.image = image
           })
       }).resume()
    }
    
    
    
    
    func configureViews() {
        trendingCollection.dataSource = self
        trendingCollection.delegate = self
        
        trendingCollection.register(UINib(nibName: reuseID, bundle: nil), forCellWithReuseIdentifier: reuseID)
        
        
        homeBtn.addTarget(self, action: #selector(gotoHomePage), for: .touchUpInside)
        discoverBtn.addTarget(self, action: #selector(gotoDiscoverPage), for: .touchUpInside)
        groupBtn.addTarget(self, action: #selector(gtotoGroupPage), for: .touchUpInside)
        
    }
    
    @objc func gotoHomePage(_ sender: UIButton) {
        resetIcons()
        homeIcon.image = UIImage(named: "homeIconClicked")
        
        if let discoverView = pageContainer.viewWithTag(-1) {
            discoverView.isHidden = true
        }
     
    }
    
    func resetIcons() {
        homeIcon.image = UIImage(named: "homeIcon")
        playIcon.image = UIImage(named: "playIcon")
//        groupIcon.image = UIImage(named: "playIcon")
    }
    
    @objc func gotoDiscoverPage(_ sender: UIButton) {
        
        resetIcons()
        playIcon.image = UIImage(named: "playIconClicked")
        
        if let discoverView = pageContainer.viewWithTag(-1) {
            discoverView.isHidden = false
            return
        }
        
        let disView = DiscoverView(frame: .zero)
        disView.tag = -1
        disView.frame = pageContainer.bounds
        
        pageContainer.addSubview(disView)
    }
    
    @objc func gtotoGroupPage(_ sender: UIButton) {

    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return trendingData?.results?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: reuseID, at: index) as! TrendingCollectionViewCell
        
        if let title = trendingData?.results?[index].originalTitle {
            cell.titleLabel.text = title
        } else {
            
        }
        
        if let rating = trendingData?.results?[index].voteAverage {
            cell.ratingsLabel.text = String(format: "%.1f", rating)
        }
        
        
        
        if let url = trendingData?.results?[index].posterPath {
            if let url = URL(string: "https://image.tmdb.org/t/p/w500"+url) {
                cell.posterView.kf.setImage(with: url)
                print(url, 1234)
            }
            
        }
        
        
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView,  OfItemsInSection section: Int) -> Int {
        return trendingData?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! TrendingCollectionViewCell
        
        if let title = trendingData?.results?[indexPath.item].originalTitle {
            cell.titleLabel.text = title
        } else {
            
        }
        
        if let rating = trendingData?.results?[indexPath.item].voteAverage {
            cell.ratingsLabel.text = String(format: "%.1f", rating)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(258, 336)
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
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        
        if let dataCount =  trendingData?.results?.count {
            if index == dataCount - 1 {
                loadNextPage()
            }
        }
    }
    
    func loadNextPage() {
        
        requestToMovieDB()
    }
}

