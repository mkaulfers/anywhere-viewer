//
//  APIService.swift
//  WireViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import Foundation

/**
 APIServiceDelegate protocol is adopted to define methods for data service interactions.
 */
protocol APIServiceDelegate {
    /**
     Method to clear the data cache.
     */
    func clearCache()
    
    /**
     Method to reload data from the endpoint and return it using a completion handler.
     - Parameters:
     - completion: A completion handler that receives a `Result` object with the downloaded data or an error.
     */
    func reloadData(completion: @escaping (Result<Data, Error>) -> Void)
}

/**
 APIService class defines methods to interact with an API endpoint and manages caching.
 */
class APIService: APIServiceDelegate {
    /// A URL session for data tasks.
    let session: URLSession
    
    /// The URL of the API endpoint.
    private var apiUrl: URL? {
        guard let configPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let configDict = NSDictionary(contentsOfFile: configPath) else { return nil }
        
        guard let apiUrlString = configDict["API_URL_KEY"] as? String,
              let apiURL = URL(string: apiUrlString) else { return nil }
        
        return apiURL
    }
    
    /**
     Method to load data from the endpoint and return it using a completion handler. If the data is cached, it is returned from the cache instead of downloading it again.
     - Parameters:
     - completion: A completion handler that receives a `Result` object with the downloaded data or an error.
     */
    func loadData(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let apiUrl = apiUrl else { return }
        
        if let cachedData = CacheService.shared.dataCache[apiUrl.absoluteString] {
            completion(.success(cachedData))
            return
        }
        
        // Create a data task to download data from the endpoint
        let task = session.dataTask(with: apiUrl) { data, response, error in
            // Handle any errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Store downloaded data in cache
            if let data = data {
                CacheService.shared.dataCache[apiUrl.absoluteString] = data
            }
            
            // Call completion handler with downloaded data
            completion(.success(data ?? Data()))
        }
        
        task.resume()
    }
    
    // MARK: - APPIServiceDelegate
    
    /**
     Method to clear the data cache.
     */
    func clearCache() {
        CacheService.shared.dataCache.removeAll()
    }
    
    /**
     Method to clear the data cache and reload data from the endpoint, returning it using a completion handler.
     - Parameters:
     - completion: A completion handler that receives a `Result` object with the downloaded data or an error.
     */
    func reloadData(completion: @escaping (Result<Data, Error>) -> Void) {
        CacheService.shared.dataCache.removeAll()
        loadData(completion: completion)
    }
    
    /**
     Static method to extract a name and a description from a given string.
     - Parameters:
     - input: The input string to parse.
     - Returns: A tuple containing the name and the description extracted from the input string, or `nil` if the input is `nil`.
     */
    static func extractNameAndDescription(from input: String?) -> (name: String?, description: String?) {
        guard let input = input else { return (nil, nil) }
        
        let components = input.components(separatedBy: " - ")
        let name = components.count > 0 ? components[0].trimmingCharacters(in: .whitespacesAndNewlines) : nil
        let description = components.count > 1 ? components[1].trimmingCharacters(in: .whitespacesAndNewlines) : nil
        return (name, description)
    }
    
    // MARK: - Init
    
    /**
     Initializes an instance of `APIService` with a default URL session.
     */
    init() {
        session = URLSession.shared
    }
}
