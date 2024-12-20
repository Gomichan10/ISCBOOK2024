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
}
