//
//  Sequence+Extension.swift
//  WireViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

//extension Array where Element: Hashable {
//    func uniqued() -> Array {
//        var buffer = Array()
//        var added = Set<Element>()
//        for elem in self {
//            if !added.contains(elem) {
//                buffer.append(elem)
//                added.insert(elem)
//            }
//        }
//        return buffer
//    }
//}
