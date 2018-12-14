//
//  Photos.swift
//  FlickrImageSearch
//
//  Created by VJ on 11/12/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import Foundation


/// Photos root nodd
struct PhotoNode: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let page: Int
    let totalPages: Int
    let perPage: Int
    
    let totalPhotos: String
    
    let photos: [Photo]
}

extension Photos {
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "pages"
        case perPage = "perpage"
        case totalPhotos = "total"
        case photos = "photo"
    }
}

struct Photo: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let title: String
    
    let farm: Int
    
    func photoURL() -> URL? {
        let path = "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
        return URL(string: path)
    }
}
