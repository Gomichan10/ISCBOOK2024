//
//  StudentAPIClient.swift
//  ISCBOOK2024
//
//  Created by img10 on 2024/11/12.
//

import Foundation
import Keys

class StudentAPIClient {
    
    //生徒情報を取得する関数
    func fetchStudentInfo(idm: String) async throws -> Student {
        let key = ISCBOOK2024Keys()
        let apiKey = key.studentAPIKey
        // エンドポイント
        guard let url = URL(string: "https://portal.iwasaki.ac.jp/portal/api/studentsFelicaApi.php?type=studentInfoByIdm") else {
            throw URLError(.badURL)
        }
        
        // URLリクエストの設定
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // マルチパートフォームデータの作成
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // HTTPボディにフォームデータを設定
        let formData = createFormData(apiKey: apiKey, idm: idm, boundary: boundary)
        request.httpBody = formData
        
        // データを取得
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 成功か
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // Jsonデコード
        let decoder = JSONDecoder()
        let student = try decoder.decode(Student.self, from: data)
        print(student)
        
        return student
    }
    
    // マルチパートデータを作成
    private func createFormData(apiKey: String, idm: String, boundary: String) -> Data {
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"secret\"\r\n\r\n".utf8))
        body.append(Data("\(apiKey)\r\n".utf8))
        
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"Idm\"\r\n\r\n".utf8))
        body.append(Data("\(idm)\r\n".utf8))
        
        body.append(Data("--\(boundary)--\r\n".utf8))
        
        return body
    }
    
}
