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
    
    // ISBN がデータベースに存在するかを確認する関数
    func checkIsbn(isbn: String) async -> Bool {
        do {
            let snapshot = try await db.collection("Book").whereField("isbn", isEqualTo: isbn).getDocuments()
            return snapshot.documents.isEmpty
        } catch {
            print("Error checking ISBN: \(error)")
            return false
        }
    }
    
    // Firestore に新しい本の情報を保存する関数
    func saveFirestore(book: BookResponse?) async -> Bool {
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
        
        let data: [String: Any] = [
            "title": titleText,
            "author": authorText,
            "detail": detailText,
            "lend": [""],
            "time": NowTime,
            "isbn": isbnText,
            "count": 1
        ]
        
        do {
            try await db.collection("Book").document().setData(data)
            return true
        } catch {
            print("Error saving Firestore document: \(error)")
            return false
        }
    }
    
}
