//
//  URLSessionProtocol.swift
//  FlickrImageSearch
//
//  Created by VJ on 24/12/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: URLRequest(url: url), completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    
}
