//
//  CacheService.swift
//  WireViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import UIKit

class CacheService {
    static let shared = CacheService()
    
    var dataCache = [String: Data]()
    var imageCache = [String: UIImage]()
}
