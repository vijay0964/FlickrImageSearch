//
//  ImageCache.swift
//  FlickrImageSearch
//
//  Created by VJ on 12/12/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import UIKit

struct ImageCache {
    static let sharedInstance = ImageCache()
    
    var cache = NSCache<NSURL, UIImage>()
    
    fileprivate func getImage(by url: URL, handler: @escaping (_ image: UIImage?) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            
            func callBack(_ image: UIImage?) {
                DispatchQueue.main.async {
                    handler(image)
                }
            }
            
            if let image = self.cache.object(forKey: url as NSURL) {
                callBack(image)
            } else {
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        self.cache.setObject(image, forKey: url as NSURL)
                        callBack(image)
                    } else {
                        callBack(nil)
                    }
                } catch (_) {
                    callBack(nil)
                }
            }
        }
    }
}

extension ImageCache {
    func loadImage(_ url: URL, handler: @escaping (_ image: UIImage?) -> Void) {
        getImage(by: url, handler: handler)
    }
}

