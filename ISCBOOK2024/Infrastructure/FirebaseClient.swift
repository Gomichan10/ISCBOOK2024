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
    func checkIsbnExists(isbn: String) async -> Bool {
        do {
            let snapshot = try await db.collection("Book").whereField("isbn", isEqualTo: isbn).getDocuments()
            return snapshot.documents.isEmpty
        } catch {
            print("Error checking ISBN: \(error)")
            return false
        }
    }
    
    // Firestore に新しい本の情報を保存する関数
    func saveFirestore(book: BookResponse) async -> Bool {
        let bookInfo = book.Items.first?.Item
        
        let currentTime = Timestamp(date: Date())
        
        let data: [String: Any] = [
            "title": bookInfo?.title ?? "タイトルがありません",
            "author": bookInfo?.author ?? "著者不明",
            "detail": bookInfo?.itemCaption ?? "説明がありません",
            "lend": [""],
            "time": currentTime,
            "isbn": bookInfo?.isbn ?? "ISBN情報なし",
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
    
    // 本を借りるときの処理
    func updateBorrowers(isbn: String, email: String) async throws {
        
        let snapshot = try await db.collection("Book").whereField("isbn", isEqualTo: isbn).getDocuments()
        
        let currentTime = Timestamp(date: Date())
        
        for document in snapshot.documents {
            let documentRef = document.reference
            try await documentRef.updateData([
                "lend": FieldValue.arrayUnion([email]),
                "time": FieldValue.arrayUnion([currentTime])
            ])
        }
    }
    
    // 借りたり返したりできる状況か判断する関数
    func checkBookAvailability(isbn: String, isBorrowing: Bool) async -> BookStatus {
        do {
            let snapshot = try await db.collection("Book").whereField("isbn", isEqualTo: isbn).getDocuments()
            
            if let document = snapshot.documents.first, let book = try? document.data(as: BookFirestore.self) {
                let validLendList = book.lend.filter { !$0.isEmpty }
                
                // 借りる場合
                if !isBorrowing {
                    if validLendList.count >= book.count {
                        return .notAvailableBorrow // 借りれない状態
                    } else {
                        return .success
                    }
                }
                
                // 返却する場合
                if isBorrowing {
                    if validLendList.isEmpty {
                        return .notAvailableReturn //返せない状態
                    } else {
                        return .success
                    }
                }
            }
        } catch {
            return .error("Firestoreエラー: \(error.localizedDescription)")
        }
        
        return .error("不明なエラーが発生しました")
    }
    
}
