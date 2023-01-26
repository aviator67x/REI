//
//  NSAttributedString.swift
//  Interngram-Bravo
//
//  Created by Aleksandra on 25.10.2022.
//

import Foundation

extension NSAttributedString {
    static func makeHyperlink(for path: String, in string: String?, as substring: String) -> NSAttributedString {
        guard let string = string else {
            return NSAttributedString()
        }
        let nsString = NSString(string: string)
        let substringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: substringRange)
        return attributedString
    }
}
