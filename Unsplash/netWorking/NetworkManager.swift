//  NetworkManager.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 21/11/25.
//

import Foundation

final class NetworkManager {
    
    // MARK: - Properties
    private static let access_key = "XrKn9CasOaRl4ylCQ2o0PkDhj_x-OyQlytxwY6GUDvo"
    
    
    // MARK: - Generic Request
    private static func performRequest<T: Decodable>(
        urlString: String,
        queryItems: [URLQueryItem] = [],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard var components = URLComponents(string: urlString) else { return }
        components.queryItems = queryItems
        
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(access_key)", forHTTPHeaderField: "Authorization")
        
        print("Sending request to:", url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request Error:", error)
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response (first 500 chars):", jsonString.prefix(500))
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                print("Decoding Error:", error)
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    
    // MARK: - Photos
    static func getEditorialPhotos(
        page: Int = 1,
        perPage: Int = 10,
        completion: @escaping (Result<[UnsplashPhotoResponse], Error>) -> Void
    ) {
        performRequest(
            urlString: "https://api.unsplash.com/photos",
            queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)")
            ],
            completion: completion
        )
    }
    
    
    // MARK: - Topics
    static func getTopics(
        page: Int = 1,
        perPage: Int = 10,
        completion: @escaping (Result<[UnsplashTopicResponse], Error>) -> Void
    ) {
        performRequest(
            urlString: "https://api.unsplash.com/topics",
            queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)")
            ],
            completion: completion
        )
    }
    
    // MARK: - Search Photos
    static func searchPhotos(
        query: String,
        page: Int = 1,
        perPage: Int = 10,
        completion: @escaping (Result<[UnsplashPhotoResponse], Error>) -> Void
    ) {
        performRequest(
            urlString: "https://api.unsplash.com/search/photos",
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)")
            ]
        ) { (result: Result<SearchPhotoResponse, Error>) in
            switch result {
            case .success(let searchResponse):
                completion(.success(searchResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}





