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
    @Published var book: BookResponse?
    @Published var reviewAverageInt: Int = 0
    @Published var isLoading: Bool = false
    @Published var isShowAlert: Bool = false
    @Published var isBorrowAlert: Bool = false
    @Published var isReturnAlert: Bool = false
    @Published var isErrorAlert: Bool = false
    
    @Published var student: Student?
    @Published var isSheetLoading: Bool = false
    @Published var errorMessage: String?
    
    private let studentAPIClient = StudentAPIClient()
    
    var bookItem: BookInfo? {
        book?.Items.first?.Item
    }
    
    // idmをもとに生徒情報を取得する関数
    func fetchStudentInfo(idm: String) async {
        isSheetLoading = false
        errorMessage = nil
        do {
            let fetchedStudent = try await studentAPIClient.fetchStudentInfo(idm: idm)
            self.student = fetchedStudent
            isSheetLoading = true
        } catch {
            self.errorMessage = "生徒情報の取得に失敗しました: \(error.localizedDescription)"
        }
    }
    
    // 本の情報を取得する関数
    func fetchBookDetail(isbn: String, isBorrowing: Bool) async {
        isLoading = false
        do {
            let isbnExists = await FirebaseClient().checkIsbnExists(isbn: isbn)
            if isbnExists {
                self.isShowAlert = true
            } else {
                let bookStatus = await FirebaseClient().checkBookAvailability(isbn: isbn, isBorrowing: isBorrowing)
                
                switch bookStatus {
                case .success:
                    book = try await fetchBook(isbn: isbn)
                    if let reviewAverageString = book?.Items.first?.Item.reviewAverage,
                       let reviewAverageDouble = Double(reviewAverageString) {
                        // 小数点を切り捨てて整数化
                        reviewAverageInt = Int(reviewAverageDouble)
                    }
                    isLoading = true
                    
                case .notAvailableBorrow:
                    isBorrowAlert = true
                
                case .notAvailableReturn:
                    isReturnAlert = true
                    
                case .error(let error):
                    print("エラー: \(error)")
                    isErrorAlert = true
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
