//
//  BookStatus.swift
//  ISCBOOK2024
//
//  Created by img10 on 2024/11/26.
//

import Foundation

enum BookStatus {
    case success
    case notAvailableBorrow
    case notAvailableReturn
    case error(String) 
}
