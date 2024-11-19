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
    
    func saveFirestore(book: BookResponse?, completion: @escaping (Bool) -> Void) {
        var titleText = "タイトルがありません"
        var authorText = "著者不明"
        var detailText = "説明がありません"
        var isbnText = "ISBN情報なし"
        let NowTime = Timestamp(date: Date())
        
        if let title = book!.Items.first?.Item.title {
            titleText = title
        } else {
            titleText = ""
        }

        if let author = book!.Items.first?.Item.author {
            authorText = author
        } else {
            authorText = ""
        }

        if let detail = book!.Items.first?.Item.itemCaption {
            detailText = detail
        } else {
            detailText = ""
        }

        if let isbn = book!.Items.first?.Item.isbn {
            isbnText = isbn
        } else {
            isbnText = ""
        }
        
        db.collection("Book").document().setData(
            [
                "title": titleText,
                "author": authorText,
                "detail": detailText,
                "lend": [""],
                "time": NowTime,
                "isbn": isbnText,
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
