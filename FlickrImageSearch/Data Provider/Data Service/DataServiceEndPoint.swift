//
//  DataServiceEndPoint.swift
//  FlickrImageSearch
//
//  Created by VJ on 11/12/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import Foundation

/// DataServiceEndPoint - which holds the end point URL and the HTTP request method.

struct DataServiceEndPoint {
    var method: String
    var url: URL
    
    init(method: String, url: URL) {
        self.method = method
        self.url = url
    }
}
