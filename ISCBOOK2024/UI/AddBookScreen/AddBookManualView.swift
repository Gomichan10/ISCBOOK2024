//
//  AddBookManualView.swift
//  ISCBOOK2024
//
//  Created by img10 on 2024/12/16.
//

import SwiftUI

struct AddBookManualView: View {
    
    @State var bookTitle: String = ""
    @State var bookAuthor: String = ""
    @State var bookDetail: String = ""
    @State var scannedCode: String?
    
    @Binding var path: NavigationPath
    
    @StateObject var bookViewModel = BookViewModel()
    
    var body: some View {
        GeometryReader { geomety in
            VStack (spacing: 30){
                
                Spacer()
                
                TextField("本のタイトル", text: $bookTitle)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding()
                
                TextField("本の著者", text: $bookAuthor)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding()
             
                TextField("本の詳細", text: $bookDetail)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding()
                
                Button {
                    if !bookTitle.isEmpty && !bookAuthor.isEmpty && !bookDetail.isEmpty {
                        guard let code = scannedCode else {
                            return
                        }
                        if let bookInfo = BookInfo(
                            title: bookTitle,
                            author: bookAuthor,
                            publisherName: "",
                            itemPrice: 0,
                            salesDate: "",
                            itemCaption: bookDetail,
                            itemUrl: "",
                            largeImageUrl: "",
                            reviewAverage: "0",
                            reviewCount: 0,
                            isbn: code
                        ) {
                            let bookItems = BookItems(Item: bookInfo)
                            let bookResponse = BookResponse(Items: [bookItems])
                            bookViewModel.book = bookResponse
                            Task {
                                let saveBookResult = await bookViewModel.saveBook()
                                if saveBookResult {
                                    path.removeLast()
                                } else {
                                    print("正常に本が保存できませんでした")
                                }
                            }
                        }
                    }
                } label: {
                    ZStack {
                        Capsule()
                            .frame(width: geomety.size.width * 0.9, height: geomety.size.height * 0.1)
                            .foregroundColor(bookTitle.isEmpty && bookAuthor.isEmpty && bookDetail.isEmpty ? .gray : .blue)
                        Text("本を追加")
                            .font(.system(size: 28))
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
            }
        }
    }
}


