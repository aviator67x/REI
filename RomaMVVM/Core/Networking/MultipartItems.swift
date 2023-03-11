//
//  MultipartItems.swift
//  RomaMVVM
//
//  Created by User on 09.03.2023.
//

import Foundation

struct MultipartItem {
    // MARK: - Static Properties
    private static let crlf = "\r\n"

    // MARK: - Public Properties
    /// The key by which the data can be written to the server.
    var name: String

    /// Name of the file, which can be transferred to the server.
    var fileName: String

    /// File type. It is an optional variable.
    var mimeType: String?

    /// Data to be added as part of the request body.
    var data: Data

    // MARK: - Init
    public init(
        name: String,
        fileName: String,
        mimeType: String? = nil,
        data: Data
    ) {
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }

    // MARK: - Fileprivate Methods
    func convert() -> Data {
        let formItemData = NSMutableData()

        formItemData.append("Content-Disposition: form-data; name=\"\(name)\"")
        formItemData.append("; filename=\"\(fileName)\"")

        if let mimeType = mimeType {
            formItemData.append(MultipartItem.crlf)
            formItemData.append("Content-Type: \(mimeType)")
        }

        formItemData.append(MultipartItem.crlf)
        formItemData.append(MultipartItem.crlf)
        formItemData.append(data)
        formItemData.append(MultipartItem.crlf)

        return formItemData as Data
    }
}

struct MultipartData {
    let data: Data
    let boundary: String
}
