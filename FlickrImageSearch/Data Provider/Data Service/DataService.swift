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

class DataService {
    
    fileprivate var task: URLSessionTask?
    
    fileprivate func request<T: Codable>(_ type: T.Type, endPoint: DataServiceEndPoint, handler: @escaping CompletionHandlerType) -> Void {
        
        task = URLSession.shared.dataTask(with: endPoint.url, completionHandler: { (data, response, error) in
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
    func getPhotos(_ text: String, handler: @escaping CompletionHandlerType) -> Void {
        let urlPath = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(flickrAPIKey)&format=json&nojsoncallback=1&safe_search=0&text=\(text)")
        let endPoint = DataServiceEndPoint(method: "GET", url: urlPath!)
        request(PhotoClass.self, endPoint: endPoint, handler: handler)
    }
}
