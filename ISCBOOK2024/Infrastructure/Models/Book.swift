//
//  Book.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/08.
//

import Foundation

// Root model
struct Book: Codable {
    let kind: String
    let totalItems: Int
    let items: [BookItem]
}

// Book item model
struct BookItem: Codable {
    let kind: String
    let id: String
    let etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo
    let accessInfo: AccessInfo
    let searchInfo: SearchInfo?
}

// Volume info model
struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publishedDate: String
    let description: String?
    let industryIdentifiers: [IndustryIdentifier]
    let pageCount: Int
    let categories: [String]?
    let averageRating: Double?
    let ratingsCount: Int?
    let language: String
    let previewLink: String
    let infoLink: String
    let imageLinks: ImageLinks?
    let canonicalVolumeLink: String
}

// Industry identifier model
struct IndustryIdentifier: Codable {
    let type: String
    let identifier: String
}

// Sale info model
struct SaleInfo: Codable {
    let country: String
    let saleability: String
    let isEbook: Bool
}

// Access info model
struct AccessInfo: Codable {
    let country: String
    let viewability: String
    let embeddable: Bool
    let publicDomain: Bool
    let textToSpeechPermission: String
    let epub: EpubInfo
    let pdf: PdfInfo
    let webReaderLink: String
}

// Epub info model
struct EpubInfo: Codable {
    let isAvailable: Bool
}

// Pdf info model
struct PdfInfo: Codable {
    let isAvailable: Bool
}

// Search info model
struct SearchInfo: Codable {
    let textSnippet: String
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}
