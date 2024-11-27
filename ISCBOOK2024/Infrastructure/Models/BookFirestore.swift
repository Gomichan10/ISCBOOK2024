//
//  BookFirestore.swift
//  ISCBOOK2024
//
//  Created by img10 on 2024/11/26.
//

import Foundation
import FirebaseFirestore

struct BookFirestore:Codable {
    let isbn: String
    let count: Int
    let lend: [String]
    let author: String
    let detail: String
    let time: Timestamp
    let title: String
}
