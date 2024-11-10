//
//  GoogleBooksAPIClient.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/08.
//

import Foundation
import Alamofire
import Keys


class GoogleBooksAPIClient {
    
    func getBookInfo(isbn: String, completion: @escaping (Result<Book, Error>) -> Void) {
        
        let keys = ISCBOOK2024Keys()
        let googleBooksAPIKey = keys.googleBooksAPIKey
        let baseURL = "https://www.googleapis.com/books/v1/volumes"
        let parameters: [String:Any] = [
            "q": "isbn:" + isbn,
            "key": googleBooksAPIKey,
        ]
        
        AF.request(baseURL, method: .get, parameters: parameters).responseDecodable(of: Book.self){ response in
            switch response.result {
            case .success(let bookResponse):
                print(bookResponse)
                completion(.success(bookResponse))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
}
