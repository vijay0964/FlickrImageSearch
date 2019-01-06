//
//  DataService.swift
//  FlickrImageSearch
//
//  Created by VJ on 11/12/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import Foundation

// Completion handler for API calls
typealias CompletionHandlerType = ((Result) -> Void)
enum Result {
    case success(AnyObject?)
    case failure(Error)
}

fileprivate let flickrAPIKey = "3e7cc266ae2b0e0d78e279ce8e361736"


/// DataService - Used for calls API services

class DataService {
    
    fileprivate var task: URLSessionDataTaskProtocol?
    private var session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    fileprivate func request<T: Codable>(_ type: T.Type, endPoint: DataServiceEndPoint, handler: @escaping CompletionHandlerType) -> Void {
        
        task = session.dataTask(with: endPoint.url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    handler(.failure(error!))
                }
                return
            }
            
            let objects = try? JSONDecoder().decode(T.self, from: data)
            DispatchQueue.main.async {
                handler(.success(objects as AnyObject))
            }
        })
        task?.resume()
    }
}

extension DataService {
    
    /// Get photos from Flickr API based on the given query
    ///
    /// - Parameters:
    ///   - text: Search query
    ///   - page: page number for which page of data taken
    ///   - handler: Completion handler to pass the call back after completing the requested opration
    func getPhotos(_ text: String, page: Int, handler: @escaping CompletionHandlerType) -> Void {
        let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlPath = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(flickrAPIKey)&format=json&nojsoncallback=1&safe_search=1&text=\(encoded)&page=\(page.description)")
        let endPoint = DataServiceEndPoint(method: "GET", url: urlPath!)
        request(PhotoNode.self, endPoint: endPoint, handler: handler)
    }
}
