//
//  Item.swift
//  Swipe-Assignment-VP
//
//  Created by Vishwas Sharma on 10/11/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class ProductModel: Codable {
    var productName: String
    var productType: String
    var price: Double
    var tax: Double
    var uploadedImageData: Data?
    var image: String? = ""

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case productType = "product_type"
        case price
        case tax
        case uploadedImageData
        case image
    }

    init(image: String? = nil, productName: String, price: Double, productType: String, tax: Double, uploadedImageData: Data? = nil) {
        self.image = image
        self.productName = productName
        self.price = price
        self.productType = productType
        self.tax = tax
        self.uploadedImageData = uploadedImageData
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.price = try container.decode(Double.self, forKey: .price)
        self.productType = try container.decode(String.self, forKey: .productType)
        self.tax = try container.decode(Double.self, forKey: .tax)
        self.uploadedImageData = try container.decodeIfPresent(Data.self, forKey: .uploadedImageData)  // Decode image data
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encode(productName, forKey: .productName)
        try container.encode(price, forKey: .price)
        try container.encode(productType, forKey: .productType)
        try container.encode(tax, forKey: .tax)
        try container.encodeIfPresent(uploadedImageData, forKey: .uploadedImageData)
    }

    func getUploadedImage() -> Image? {
        guard let imageData = uploadedImageData, let uiImage = UIImage(data: imageData) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
}
