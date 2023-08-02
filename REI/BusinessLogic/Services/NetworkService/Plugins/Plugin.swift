//
//  Plugin.swift
//  REI
//
//  Created by User on 20.04.2023.
//

import Foundation
public protocol Plugin {
    func modifyRequest(_ request: inout URLRequest)
}
