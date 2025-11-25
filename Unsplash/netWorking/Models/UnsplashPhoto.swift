//
//  UnsplashPhoto.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 21/11/25.
//


import Foundation

// MARK: - Photo Models
struct UnsplashPhotoResponse: Decodable {
    let id: String
    let width: Int
    let height: Int
    let description: String?
    let urls: PhotoURLs
    let user: User
}

struct PhotoURLs: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct User: Decodable {
    let id: String
    let name: String
    let username: String
}

// MARK: - Topic Models
struct UnsplashTopicResponse: Decodable {
    let id: String
    let title: String
    let slug: String
    let total_photos: Int
    let cover_photo: CoverPhoto?
    let preview_photos: [PreviewPhoto]?
}

struct CoverPhoto: Decodable {
    let id: String
    let width: Int
    let height: Int
    let description: String?
    let alt_description: String?
    let urls: PhotoURLs
}

struct PreviewPhoto: Decodable {
    let id: String
    let urls: PhotoURLs
}

// MARK: - Search Photo Response
struct SearchPhotoResponse: Decodable {
    let total: Int
    let total_pages: Int
    let results: [UnsplashPhotoResponse]
}
