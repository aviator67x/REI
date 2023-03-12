//
//  Array.swift
//
import Foundation

extension Array {
    func isValidIndex(_ index: Int) -> Bool {
        return index < self.count
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        let isValidIndex = index >= 0 && index < count

        return isValidIndex ? self[index] : nil
    }
}
