//
//  AddBookView.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/13.
//

import Foundation
import SwiftUI

struct AddBookView: View {
    
    @State private var showSheet: Bool = false
    @State private var isExpanded: Bool = false
    @State private var isShowAlert: Bool = false
    @State var isLoding: Bool = false
    @Binding var scannedCode: String?
    
    @Environment(\.dismiss) var dismiss
    
    @State var book: Book = Book(kind: "", totalItems: 0, items: [])
    
    var body: some View {
        VStack {
            BookImageArea
                .onAppear {
                    if let code = scannedCode {
                        FirebaseClient().checkIsbn(isbn: code) { result in
                            switch result {
                            case true:
                                GoogleBooksAPIClient().getBookInfo(isbn: code) { result in
                                    switch result {
                                    case .success(let bookResponse):
                                        book = bookResponse
                                        isLoding = true
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                            case false:
                                isShowAlert = true
                            }
                        }
                        
                    } else {
                        print("Error")
                    }
                }
            Spacer()
            InputArea
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
        .alert("この方はすでに追加されています", isPresented: $isShowAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("違う本を追加してください")
        }
    }
}


extension AddBookView {
    
    var BookImageArea: some View {
        ScrollView {
            VStack (alignment: .leading) {
                ZStack {
                    if let imageUrlString = book.items.first?.volumeInfo.imageLinks?.thumbnail,
                       let imageUrl = URL(string: imageUrlString) {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 225)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                        } placeholder: {
                            Image(systemName: "book.fill")
                                .resizable()
                                .frame(width: 200, height: 150)
                        }
                    } else {
                        Image(systemName: "book.fill")
                            .resizable()
                            .frame(width: 200, height: 150)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 450)
                .background(Color.gray.opacity(0.7))
                Spacer()
                VStack (){
                    Text(book.items.first?.volumeInfo.authors?.first ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    
                    Text(book.items.first?.volumeInfo.title ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    
                    Spacer()
                        .frame(height: 10)
                    
                    switch Int(book.items.first?.volumeInfo.averageRating ?? 0) {
                    case 0:
                        Text("☆☆☆☆☆(\(book.items.first?.volumeInfo.ratingsCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical, 4)
                    case 1:
                        Text("★☆☆☆☆(\(book.items.first?.volumeInfo.ratingsCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical)
                    case 2:
                        Text("★★☆☆☆(\(book.items.first?.volumeInfo.ratingsCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical)
                    case 3:
                        Text("★★★☆☆(\(book.items.first?.volumeInfo.ratingsCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                    case 4:
                        Text("★★★★☆(\(book.items.first?.volumeInfo.ratingsCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical)
                    case 5:
                        Text("★★★★★(\(book.items.first?.volumeInfo.ratingsCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical)
                    default:
                        Text ("")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical)
                    }
                }
                .font(.system(size: 22.0))
                .padding(.leading, 20)
                
                Divider()
                    .frame(height: 1)
                    .background(.gray.opacity(0.1))
                VStack {
                    HStack {
                        Text("本詳細")
                            .font(.subheadline)
                            .bold()
                            .padding(.leading, 5)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down") // 矢印アイコン
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .onTapGesture {
                        // タップしたら展開・閉じを切り替える
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // 0.5秒の遅延
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }
                    }
                    
                    // isExpandedがtrueのときに表示されるテキスト
                    if isExpanded {
                        Text(book.items.first?.volumeInfo.description ?? "本の詳細がありません")
                            .padding()
                            .transition(.opacity)
                    }
                }
                .background(Color.gray.opacity(0.1))
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            Spacer()
            
        }
    }
    
    var InputArea: some View {
        HStack {
            Button(action: {
                dismiss()
            }, label: {
                ZStack {
                    Circle()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.gray)
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                }
            })
            .padding(.vertical)
            Button(action: {
                if isLoding {
                    FirebaseClient().saveFirestore(book: book) { result in
                        switch result {
                        case true:
                            print("Succses")
                            dismiss()
                        case false:
                            print("error")
                        }
                    }
                }
            }, label: {
                ZStack {
                    Rectangle()
                        .frame(width: 280, height: 55)
                        .cornerRadius(8.0)
                    Text("本を追加")
                        .foregroundColor(.white)
                        .bold()
                        .font(.system(size: 18.0))
                }
            })
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .shadow(radius: 10)
        .ignoresSafeArea()
    }
}
