//
//  ImageService.swift
//  WireViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import Foundation
import UIKit

/**
 `ImageService` is a class that provides a static method to download images and cache them using a `CacheService`.
 */
class ImageService {
    
    /// A queue for network requests, limiting the number of concurrent tasks to 5.
    static let networkQueue = NetworkQueue(maxConcurrentTasks: 5)
    
    /**
     Static method to download an image from a given URL and return it using a completion handler. If the image is already cached, it is returned from the cache instead of downloading it again.
     - Parameters:
        - urlString: The URL of the image to download.
        - completion: A completion handler that receives the downloaded image or `nil`.
     */
    static func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let completeUrlString = "https://duckduckgo.com/\(urlString)"
        
        if let image = CacheService.shared.imageCache[completeUrlString] {
            completion(image)
            return
        }
        
        guard let url = URL(string: completeUrlString) else {
            completion(UIImage(systemName: "person.crop.circle.dashed"))
            return
        }
        
        networkQueue.async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    let image = UIImage(systemName: "person.crop.circle.badge.xmark")
                    CacheService.shared.imageCache[completeUrlString] = image
                    completion(image)
                } else if let data = data, let image = UIImage(data: data) {
                    CacheService.shared.imageCache[completeUrlString] = image
                    completion(image)
                } else {
                    let image = UIImage(systemName: "person.crop.circle.badge.questionmark")
                    completion(image)
                }
            }.resume()
        }
    }
}
