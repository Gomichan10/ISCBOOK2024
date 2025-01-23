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
    @Published var isBorrowedAlert: Bool = false
    @Published var isReturnSuccess: Bool = false
    @Published var isBorrowedSuccess: Bool = false
    @Published var isAdded: Bool = false
    @Published var isNotExist: Bool = false
    @Published var isErrorSave: Bool = false
    
    @Published var student: Student?
    @Published var isSheetLoading: Bool = false
    @Published var errorMessage: String?
    
    private let studentAPIClient = StudentAPIClient()
    
    var bookItem: BookInfo? {
        book?.Items.first?.Item
    }
    
    var studentInfo: StudentDetails? {
        student?.student
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
                    } else {
                        book = await FirebaseClient().getBookDetail(isbn: isbn)
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
    
    // 本を追加する画面の本の情報を取得する関数
    func fetchAddBookDetail(isbn: String) async {
        isLoading = false
        do {
            let isbnExists = await FirebaseClient().checkIsbnExists(isbn: isbn)
            if isbnExists {
                book = try await fetchBook(isbn: isbn)
                if let reviewAverageString = book?.Items.first?.Item.reviewAverage,
                   let reviewAverageDouble = Double(reviewAverageString) {
                    // 小数点を切り捨てて整数化
                    reviewAverageInt = Int(reviewAverageDouble)
                } else {
                    isNotExist = true
                }
                isLoading = true
            } else {
                isAdded = true
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    // 本をすでに借りているか確認する関数
    func checkBorrowStatus(isbn: String, email: String) async -> Bool {
        let isBorrowed = await FirebaseClient().checkBorrowedStatus(isbn: isbn, email: email)
        if isBorrowed {
            return true
        } else {
            print("User \(email) has not borrowed the book with ISBN \(isbn).")
            return false
        }
    }
    
    // 本を借りる、または返すときの関数
    func borrowReturnBook(isbn: String, email: String, isBorrowing: Bool) async {
        do {
            if isBorrowing {
                // 本を借りているか確認
                let isAlreadyBorrowed = await checkBorrowStatus(isbn: isbn, email: email)
                if isAlreadyBorrowed {
                    self.isBorrowedAlert = true
                } else {
                    // 本を借りる処理
                    try await FirebaseClient().borrowBook(isbn: isbn, email: email)
                    self.isBorrowedSuccess = true
                }
            } else {
                // 本を返す処理
                try await FirebaseClient().returnBook(isbn: isbn, email: email)
                self.isReturnSuccess = true
            }
        } catch {
            print("An error occurred: \(error.localizedDescription)")
        }
    }
    
    // 本を追加するための関数
    func saveBook() async -> Bool {
        guard let book = book else {
            print("本の情報を取得できませんでした")
            isErrorSave = true
            return false
        }
        
        let saveBookResult = await FirebaseClient().saveFirestore(book: book)
        
        if saveBookResult {
            isErrorSave = false
            return true
        } else {
            isErrorSave = true
            return false
        }
    }
    
}
