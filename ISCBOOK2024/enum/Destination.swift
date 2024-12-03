//
//  Destination.swift
//  ISCBOOK2024
//
//  Created by img10 on 2024/11/21.
//

import Foundation

enum Destination: Hashable {
    case lending
    case returning
    case bookView(code: String, isBorrowing: Bool)
    case addBookView(code: String)
}
