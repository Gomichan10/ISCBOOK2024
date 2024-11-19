//
//  BookViewModel.swift
//  ISCBOOK2024
//
//  Created by img10 on 2024/11/14.
//

import Foundation
import SwiftUI

@MainActor
class BookViewModel: ObservableObject {
    @Published var student: Student?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let studentAPIClient = StudentAPIClient()
    
    func fetchStudentInfo(idm: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let fetchedStudent = try await studentAPIClient.fetchStudentInfo(idm: idm)
            self.student = fetchedStudent
        } catch {
            self.errorMessage = "生徒情報の取得に失敗しました: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
