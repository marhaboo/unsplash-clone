//
//  NetworkManager.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 21/11/25.
//

import Foundation


final class NetworkManager {
    
    private static let access_key = "XrKn9CasOaRl4ylCQ2o0PkDhj_x-OyQlytxwY6GUDvo"
    
    static func getEditorialPhotos(
        page: Int = 1,
        perPage: Int = 10,
        completion: @escaping (Result<[UnsplashPhotoResponse], Error>) -> Void
    ) {
        guard var components = URLComponents(string: "https://api.unsplash.com/photos") else { return }
        
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
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
                let photos = try JSONDecoder().decode([UnsplashPhotoResponse].self, from: data)
                print("Decoded photos count:", photos.count)
                completion(.success(photos))
            } catch {
                print("Decoding Error:", error)
                completion(.failure(error))
            }
            
        }.resume()
    }
}
