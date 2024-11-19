//
//  Student.swift
//  ISCBOOK2024
//
//  Created by img10 on 2024/11/12.
//

import Foundation

struct Student: Codable {
    let result: String
    let student: StudentDetails?
}

struct StudentDetails: Codable {
    let id: String
    let `class`: String
    let number: Int
    let name: String
    let email: String
}
