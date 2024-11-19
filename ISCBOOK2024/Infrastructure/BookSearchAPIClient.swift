//
//  BookSearchAPIClient.swift
//  ISCBOOK2024
//
//  Created by img10 on 2024/11/18.
//

import Foundation
import Keys

// 楽天APIのリクエストを行う関数
func fetchBook(isbn: String) async throws -> BookResponse {
    let key = ISCBOOK2024Keys()
    let apiKey = key.bookSearchAPIKey
    let urlString = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?applicationId=\(apiKey)&isbn=\(isbn)&format=json"
    
    // URLを作成
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    // リクエストを送信
    let (data, response) = try await URLSession.shared.data(from: url)
    
    // 正常なレスポンスが返ってきたか確認
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    let decodedResponse = try JSONDecoder().decode(BookResponse.self, from: data)
    return decodedResponse
}
