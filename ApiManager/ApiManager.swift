//
//  ApiManager.swift
//  MovieBrowsing
//
//  Created by common_sz on 8/29/23.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    private init() {}
    
    private let apiKey = "38e61227f85671163c275f9bd95a8803"
    private let baseUrl = "https://api.themoviedb.org/3"
    private var endpoint = "/trending/all/week"
    
    private var baseUrlForRecommandation = "https://api.themoviedb.org/3/movie/28/recommendations"
    
    
    
    
    func fetchData<T: Codable>(endPoint: String, genre: String = "", movieID: String = "", query: String = "", currentPage: Int, completion: @escaping (Result<T, Error>) -> Void) {
        
        var urlString = "\(baseUrl)\(endPoint)?api_key=\(apiKey)&page=\(currentPage)"
//        var urlString = "\(baseUrl)\(endPoint)?api_key=\(apiKey)"
        
        if !genre.isEmpty {
            urlString += "&with_genres=\(genre)"
        }
        
        if !movieID.isEmpty {
            urlString += "/movie/\(movieID)/recommendations"
        }
        
        if !query.isEmpty {
            let constant = "&query="
            let processedQuery = processQuery(query: query)
            
            urlString += constant
            urlString += processedQuery
        }
        
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkError.noData))
                return
            }
    
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            print(data)
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                // Step 1: Get the URL for the Documents directory
                completion(.success(decodedData))
            } catch {
                completion(.failure(NetworkError.decodeError))
            }
        }.resume()
    }
    
    private func processQuery(query: String) -> String {
        return query.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidResponse
    case decodeError
}
