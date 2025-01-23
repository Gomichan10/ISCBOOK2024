//
//  BooksResponse.swift
//  ISCBOOK2024
//
//  Created by img10 on 2024/11/18.
//

import Foundation

struct BookResponse: Codable {
    let Items: [BookItems]
}

struct BookItems: Codable {
    let Item: BookInfo
}

struct BookInfo: Codable {
    let title: String
    let author: String
    let publisherName: String
    let itemPrice: Int
    let salesDate: String
    let itemCaption: String
    let itemUrl: String
    let largeImageUrl: String
    let reviewAverage: String
    let reviewCount: Int
    let isbn: String
    
    init?(title: String, author: String, publisherName: String, itemPrice: Int, salesDate: String, itemCaption: String, itemUrl: String, largeImageUrl: String, reviewAverage: String, reviewCount: Int, isbn: String) {
        
        guard !title.isEmpty, !author.isEmpty, !isbn.isEmpty else {
            return nil
        }
        
        self.title = title
        self.author = author
        self.publisherName = publisherName
        self.itemPrice = itemPrice
        self.salesDate = salesDate
        self.itemCaption = itemCaption
        self.itemUrl = itemUrl
        self.largeImageUrl = largeImageUrl
        self.reviewAverage = reviewAverage
        self.reviewCount = reviewCount
        self.isbn = isbn
    }
}
