//
//  DiscoverView.swift
//  MovieBrowsing
//
//  Created by Mubin Khan on 8/29/23.
//

import UIKit
import Kingfisher

enum Endpoint {
    static let movies = "/discover/movie"
    static let tvSeries = "/discover/tv"
    static let documentary = "99"
    static let sports = "10767"
}

class DiscoverView: UIView, UICollectionViewDataSource, UICollectionViewDelegateWaterfallLayout, CategorySelectionDelegate {
    
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var contenCollectionView: UICollectionView!
    
    var minimumInterItemSpacing: CGFloat = 19
    var minimumCellInset: CGFloat = 24
    var numberOfColumn: CGFloat = 2
    let apiKey = "38e61227f85671163c275f9bd95a8803"
    
    var images: [UIImage] = []

    private let contentReuseID = "ContentViewCell"
    private let selectedCategory = 0
    
    var currentPage = 1
    var discoverEndpoing = "/discover/movie"
    var genra = ""
    var query = ""
    
    var discoverData: DiscoverResponse?
    private var _discoverData: DiscoverResponse? {
        didSet {
            if discoverData == nil {
                discoverData = _discoverData
                return
            }
            discoverData?.results?.append(contentsOf: (_discoverData?.results)!)
    
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
        
//        categoryCollectionView.dataSource = self
//        categoryCollectionView.delegate = self
//        categoryCollectionView.register(UINib(nibName: categoryReuseID, bundle: nil), forCellWithReuseIdentifier: categoryReuseID)
        
        contenCollectionView.dataSource = self
        contenCollectionView.delegate = self
        contenCollectionView.register(UINib(nibName: contentReuseID, bundle: nil), forCellWithReuseIdentifier: contentReuseID)
        
        setCategoryView()
        
        searchContainer.layer.backgroundColor = UIColor(red: 0.13, green: 0.12, blue: 0.19, alpha: 1).cgColor
        searchContainer.layer.cornerRadius = 20
        searchContainer.clipsToBounds = true
        
        let placeholderText = "Search"
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1),
            .font: searchField.font!  // Use the same font as the text field
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        searchField.attributedPlaceholder = attributedPlaceholder
        
        containerView.layer.backgroundColor = UIColor(red: 0.084, green: 0.078, blue: 0.121, alpha: 1).cgColor
        
        requestToMovieDB()
        
        searchField.delegate = self
        searchField.returnKeyType = .search
        cancelView.isHidden = true
        cancelBtn.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        
    }
    
    func setCategoryView() {
        let category = CategoryContainerView(frame: .zero)
        category.frame = categoryContainerView.bounds
        category.delegate = self
        categoryContainerView.addSubview(category)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
    func requestToMovieDB() {
        ApiManager.shared.fetchData(endPoint: discoverEndpoing, genre: genra, query: query, currentPage: currentPage, completion: { [self](result: Result<DiscoverResponse, Error>) in
            
            switch result {
            case .success(let data):
                _discoverData = data
                print(data)
                
                DispatchQueue.main.async {
                    self.contenCollectionView.reloadData()
                    if self.currentPage == 1 {
                        if let data = self.discoverData?.results, !data.isEmpty {
                            self.contenCollectionView?.setContentOffset(.zero, animated: false)
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
        
        return discoverData?.results?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentReuseID, for: indexPath) as! ContentViewCell
        cell.movieTitle.text = discoverData?.results?[indexPath.item].originalTitle
        
        if let posterPath = discoverData?.results?[indexPath.item].posterPath {
            
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)?api_key=\(apiKey)") {
                cell.posterView.kf.setImage(with: url)
            }
            
        }
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = floor((contenCollectionView.frame.width - (self.minimumInterItemSpacing * (numberOfColumn - 1)) - (self.minimumCellInset * 2)) / numberOfColumn)
        var cellHeight: CGFloat = 184
        
        print(cellWidth)
          
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
       URLSession.shared.dataTask(with: url) { data, response, error in
           guard let data = data, error == nil else {
               completion(nil)
               return
           }
           
           let image = UIImage(data: data)
           completion(image)
       }.resume()
   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: minimumCellInset, bottom: 0, right: minimumCellInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberOfColumnsInSection section: Int) -> Int {
        return Int(numberOfColumn)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumColumnSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsView = DetailsView(frame: .zero)
        detailsView.frame = containerView.bounds
        if let data = discoverData?.results?[indexPath.item] {
            detailsView.movieTitle.text = data.originalTitle
            detailsView.rationgLabel.text = String(format: "%.1f", data.voteAverage ?? "Unknown")
            detailsView.releaseDateLabel.text = dateFormatter(dateString: data.releaseDate!)
            detailsView.symposisLabel.text = data.overview
            detailsView.movieID = "\(data.id)"
            
            let cell = contenCollectionView.cellForItem(at: indexPath) as! ContentViewCell
            detailsView.posterView.image = cell.posterView.image
        }
       
        containerView.addSubview(detailsView)
    }
    
    func dateFormatter(dateString: String) -> String {
        let dateString = dateString
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-d"

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM d, yyyy"
            let formattedDate = outputFormatter.string(from: date)
            print(formattedDate) // Output: "December 9, 2017"
            
            return formattedDate
        } else {
            print("Invalid date string")
            return ""
        }
        
    }
    
    func selectedCategory(categoryIndex: Int) {
        switch categoryIndex {
        case 0:
            discoverEndpoing = Endpoint.movies
            genra = ""
        case 1:
            discoverEndpoing = Endpoint.tvSeries
            genra = ""
        case 2:
            discoverEndpoing = Endpoint.tvSeries
            genra = Endpoint.documentary
        case 3:
            discoverEndpoing = Endpoint.tvSeries
            genra = Endpoint.sports
        default:
            break
        }
        
        discoverData = nil
        currentPage = 1
        
        requestToMovieDB()
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

extension DiscoverView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            print(text)
            query = text
            discoverData = nil
            
            requestToMovieDB()
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    @objc func cancelSearch() {
        searchField.text = .none
        cancelView.isHidden = true
        searchField.resignFirstResponder()
        
        discoverData = nil
        query = ""
        requestToMovieDB()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelView.isHidden = false
    }
}
