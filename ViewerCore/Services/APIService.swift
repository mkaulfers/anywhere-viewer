//
//  APIService.swift
//  WireViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import Foundation

// MARK: - APIServiceDelegate Protocol
protocol APIServiceDelegate {
    func clearCache()
    func reloadData(completion: @escaping (Result<Data, Error>) -> Void)
}

// MARK: - APIService
class APIService: APIServiceDelegate {
    let session: URLSession
    
    private var apiUrl: URL? {
        guard let configPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let configDict = NSDictionary(contentsOfFile: configPath) else { return nil }
        
        guard let apiUrlString = configDict["API_URL_KEY"] as? String,
                let apiURL = URL(string: apiUrlString) else { return nil }
        
        return apiURL
    }
    
    func loadData(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let apiUrl else { return }
        
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
        
        // Start the data task
        task.resume()
    }
    
    // MARK: - APPIServiceDelegate
    func clearCache() {
        CacheService.shared.dataCache.removeAll()
    }

    func reloadData(completion: @escaping (Result<Data, Error>) -> Void) {
        CacheService.shared.dataCache.removeAll()
        loadData(completion: completion)
    }
    
    static func extractNameAndDescription(from input: String?) -> (name: String?, description: String?) {
        guard let input else { return (nil, nil) }
        
        let components = input.components(separatedBy: " - ")
        let name = components.count > 0 ? components[0].trimmingCharacters(in: .whitespacesAndNewlines) : nil
        let description = components.count > 1 ? components[1].trimmingCharacters(in: .whitespacesAndNewlines) : nil
        return (name, description)
    }
    
    // MARK: - Init
    init() {
        session = URLSession.shared
    }
}
