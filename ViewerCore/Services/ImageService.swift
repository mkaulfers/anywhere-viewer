//
//  ImageService.swift
//  WireViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import Foundation
import UIKit

enum ImageDownloadError: Error {
    case invalidURL
    case downloadError
}

class ImageService {
    static let networkQueue = NetworkQueue(maxConcurrentTasks: 5)
    
    static func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let completeUrlString = "https://duckduckgo.com/\(urlString)"
        
        if let image = CacheService.shared.imageCache[completeUrlString] {
            completion(image)
            return
        }
        
        guard let url = URL(string: completeUrlString) else {
            completion(UIImage(systemName: "xmark.circle"))
            return
        }
        
        networkQueue.async {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    let image = UIImage(systemName: "xmark.circle")
                    CacheService.shared.imageCache[completeUrlString] = image
                    completion(image)
                } else if let data = data, let image = UIImage(data: data) {
                    CacheService.shared.imageCache[completeUrlString] = image
                    completion(image)
                } else {
                    let image = UIImage(systemName: "person")
                    completion(image)
                }
            }.resume()
        }
    }
}
