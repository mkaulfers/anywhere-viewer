//
//  CacheService.swift
//  WireViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import UIKit

/**
 `CacheService` is a singleton class that provides a cache for data and images.
 */
class CacheService {
    
    /// The shared instance of `CacheService`.
    static let shared = CacheService()
    
    /// A dictionary to store cached data, with the URL string as key and the data as value.
    var dataCache = [String: Data]()
    
    /// A dictionary to store cached images, with the URL string as key and the image as value.
    var imageCache = [String: UIImage]()
}
