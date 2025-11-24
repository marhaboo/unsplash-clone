//
//  UnsplashPhoto.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 21/11/25.
//


import Foundation

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
