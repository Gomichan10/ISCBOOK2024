//
//  FirebaseClient.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/10.
//

import Foundation
import FirebaseFirestore

class FirebaseClient {
    
    private let db = Firestore.firestore()
    
    func checkIsbn(isbn: String, completion: @escaping (Bool) -> Void) {
        db.collection("Book").whereField("isbn", isEqualTo: isbn).getDocuments { snapshot, error in
            if let error = error {
                print(error)
                completion(false)
                return
            } else {
                if let documents = snapshot?.documents, documents.isEmpty {
                    completion(true)
                    return
                } else {
                    completion(false)
                    return
                }
            }
        }
    }
    
    func saveFirestore(book: Book, completion: @escaping (Bool) -> Void) {
        var titleText = "タイトルがありません"
        var authorText = "著者不明"
        var detailText = "説明がありません"
        var isbn13Text = "ISBN情報なし"
        let NowTime = Timestamp(date: Date())
        
        if let title = book.items.first?.volumeInfo.title {
            titleText = title
        } else {
            titleText = ""
        }

        if let authors = book.items.first?.volumeInfo.authors, let firstAuthor = authors.first {
            authorText = firstAuthor
        } else {
            authorText = ""
        }

        if let detail = book.items.first?.volumeInfo.description {
            detailText = detail
        } else {
            detailText = ""
        }

        if let isbn13 = book.items.first?.volumeInfo.industryIdentifiers.first(where: { $0.type == "ISBN_13" })?.identifier {
            isbn13Text = isbn13
        } else {
            isbn13Text = ""
        }
        
        db.collection("Book").document().setData(
            [
                "title": titleText,
                "author": authorText,
                "detail": detailText,
                "lend": [""],
                "time": NowTime,
                "isbn": isbn13Text,
                "count": 1
            ]
        ) { error in
            if let error = error {
                print(error)
                completion(false)
            } else {
                completion(true)
            }
            
        }
    }
    
    
    
}
