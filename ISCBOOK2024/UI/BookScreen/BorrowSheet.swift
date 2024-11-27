//
//  BorrowAlert.swift
//  ISCBOOK2024
//
//  Created by img10 on 2024/11/13.
//

import SwiftUI

struct BorrowSheet: View {
    
    @State var book: BookResponse?
    @State var isBorrowing: Bool
    
    @Binding var isBorrowedAlert: Bool
    @Binding var isReturnedAlert: Bool
    @Binding var isShowSheet: Bool
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var bookViewModel: BookViewModel
    @ObservedObject var felicaReader: FelicaReader
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("本情報")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .font(.title2)
                HStack {
                    let imageUrl = URL(string: bookViewModel.bookItem?.largeImageUrl ?? "")
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80)
                                .shadow(radius: 8)
                                .padding()
                        case .failure:
                            Image(systemName: "book.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    VStack {
                        Text(bookViewModel.bookItem?.author ?? "")
                            .foregroundColor(.gray)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(bookViewModel.bookItem?.title ?? "")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Divider()
                
                Text("生徒情報")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .font(.title2)
                HStack {
                    Spacer()
                        .frame(width: 5)
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding(.horizontal)
                    VStack {
                        Text(bookViewModel.studentInfo?.name ?? "")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(bookViewModel.studentInfo?.email ?? "")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Button {
                    if bookViewModel.isSheetLoading {
                        if isBorrowing {
                            Task {
                                do {
                                    guard let isbn = bookViewModel.bookItem?.isbn, let email = bookViewModel.studentInfo?.email else {
                                        return
                                    }
                                    try await FirebaseClient().returnBook(isbn: isbn, email: email)
                                    isReturnedAlert = true
                                    dismiss()
                                } catch {
                                    print("An error occurred while returning the book: \(error.localizedDescription)")
                                }
                            }
                        } else {
                            Task {
                                do {
                                    try await FirebaseClient().borrowBook(isbn: book?.Items.first?.Item.isbn ?? "", email: bookViewModel.student?.student?.email ?? "")
                                    isBorrowedAlert = true
                                    dismiss()
                                } catch {
                                    print("An error occurred while adding to the array: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                } label: {
                    ZStack {
                        Capsule()
                            .frame(width: 370, height: 60)
                            .foregroundColor(bookViewModel.isSheetLoading ? .blue : .gray)
                            .shadow(radius: 8)
                        Text(isBorrowing ? "本を返す" : "本を借りる")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                
            }
            .toolbar {
                Button {
                    felicaReader.idm = ""
                    isShowSheet.toggle()
                } label: {
                    ZStack {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 20, height: 20)
                            .bold()
                    }
                }
            }
        }
    }
}


