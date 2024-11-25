//
//  BorrowAlert.swift
//  ISCBOOK2024
//
//  Created by img10 on 2024/11/13.
//

import SwiftUI

struct BorrowSheet: View {
    
    @State var book: BookResponse?
    
    @Binding var isBorrowedAlert: Bool
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
                    let imageUrl = URL(string: book?.Items.first?.Item.largeImageUrl ?? "")
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
                        Text(book?.Items.first?.Item.author ?? "")
                            .foregroundColor(.gray)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(book?.Items.first?.Item.title ?? "")
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
                        Text(bookViewModel.student?.student?.name ?? "")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(bookViewModel.student?.student?.email ?? "")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Button {
                    Task {
                        do {
                            try await FirebaseClient().updateBorrowers(isbn: book?.Items.first?.Item.isbn ?? "", email: bookViewModel.student?.student?.email ?? "")
                            isBorrowedAlert = true
                            dismiss()
                        } catch {
                            print("An error occurred while adding to the array: \(error)")
                        }
                    }
                } label: {
                    ZStack {
                        Capsule()
                            .frame(width: 370, height: 60)
                            .shadow(radius: 8)
                        Text("本を借りる")
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


