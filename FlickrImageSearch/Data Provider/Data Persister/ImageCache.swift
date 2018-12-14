//
//  ImageCache.swift
//  FlickrImageSearch
//
//  Created by VJ on 12/12/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import UIKit


/// ImageCache - to store the downloaded images to the cache
struct ImageCache {
    static let sharedInstance = ImageCache()
    
    fileprivate var cache = NSCache<NSURL, UIImage>()
    
    /// Download images for the URL
    ///
    /// - Parameters:
    ///   - url: url to download
    ///   - handler: Completion handler to send the downloaded image back
    fileprivate func getImage(by url: URL, handler: @escaping (_ image: UIImage?) -> Void) {
        
        if let image = self.cache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                handler(image)
            }
        } else {
            DispatchQueue.global(qos: .background).async {
                func callBack(_ image: UIImage?) {
                    DispatchQueue.main.async {
                        if let _image = image {
                            self.cache.setObject(_image, forKey: url as NSURL)
                        }
                        handler(image)
                    }
                }
                
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
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
    
    /// Get downloaded images by URL
    ///
    /// - Parameter url: url to find the image
    /// - Returns: returns the downloaded image if found or nil
    func getImage(_ url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    /// Download images for the URL
    ///
    /// - Parameters:
    ///   - url: url to download
    ///   - handler: Completion handler to send the downloaded image back
    func loadImage(_ url: URL, handler: @escaping (_ image: UIImage?) -> Void) {
        getImage(by: url, handler: handler)
    }
}

