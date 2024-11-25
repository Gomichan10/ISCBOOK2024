//
//  BookView.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/08.
//

import SwiftUI

struct BookView: View {
    
    @State private var showSheet: Bool = false
    @State private var isExpanded: Bool = false
    @State private var isShowAlert: Bool = false
    @State var isBorrowedAlert: Bool = false
    @State var isLoading: Bool = false
    @State var isShowSheet: Bool = false
    @State var book: BookResponse?
    @State var reviewAverageInt: Int = 0
    @State var scannedCode: String?
    @State var isBorrowing: Bool?
    
    @StateObject var felicaReader = FelicaReader()
    @StateObject var bookViewModel = BookViewModel()
    
    @Binding var path: NavigationPath
    
    
    var body: some View {
        VStack {
            BookImageArea
                .onAppear {
                    if let code = scannedCode {
                        Task {
                            let isbnExists = await FirebaseClient().checkIsbn(isbn: code)
                            if isbnExists {
                                isShowAlert = true
                            } else {
                                Task {
                                    do {
                                        book = try await fetchBook(isbn: code)
                                        if let reviewAverageString = book?.Items.first?.Item.reviewAverage,
                                           let reviewAverageDouble = Double(reviewAverageString) {
                                            // 小数点を切り捨てて整数化
                                            reviewAverageInt = Int(reviewAverageDouble)
                                        }
                                        isLoading.toggle()
                                    } catch {
                                        print("Error: \(error)")
                                    }
                                }
                            }
                        }
                    } else {
                        print("Error")
                    }
                }
            Spacer()
            InputArea
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
        .alert("この本は借りれません", isPresented: $isShowAlert) {
            Button("OK") {
                path.removeLast()
            }
        } message: {
            Text("図書コーナーにある本を借りてください")
        }
        .alert("本の貸し出しが完了しました", isPresented: $isBorrowedAlert) {
            Button("OK") {
                path.removeLast(path.count)
            }
        } message: {
            Text("返却期限までに本を返却してください")
        }
        .sheet(isPresented: $isShowSheet) {
            VStack {
                BorrowSheet(book: book, isBorrowedAlert: $isBorrowedAlert,isShowSheet: $isShowSheet, bookViewModel: bookViewModel, felicaReader: felicaReader)
            }
            .presentationDetents([.medium])
        }
    }
}


extension BookView {
    
    var BookImageArea: some View {
        ScrollView {
            VStack (alignment: .leading) {
                ZStack {
                    if let imageUrlString = book?.Items.first?.Item.largeImageUrl,
                       let imageUrl = URL(string: imageUrlString) {
                        AsyncImage(url: imageUrl) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 225)
                                    .shadow(radius: 8)
                                    .padding(.top, 10)
                            case .failure:
                                Image(systemName: "book.fill")
                                    .resizable()
                                    .frame(width: 200, height: 150)
                            @unknown default:
                                EmptyView()
                            }
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
                    Text(book?.Items.first?.Item.author ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    
                    Text(book?.Items.first?.Item.title ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    
                    Spacer()
                        .frame(height: 10)
                    
                    switch reviewAverageInt {
                    case 0:
                        Text("☆☆☆☆☆(\(book?.Items.first?.Item.reviewCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical, 4)
                    case 1:
                        Text("★☆☆☆☆(\(book?.Items.first?.Item.reviewCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical)
                    case 2:
                        Text("★★☆☆☆(\(book?.Items.first?.Item.reviewCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical)
                    case 3:
                        Text("★★★☆☆(\(book?.Items.first?.Item.reviewCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                    case 4:
                        Text("★★★★☆(\(book?.Items.first?.Item.reviewCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical)
                    case 5:
                        Text("★★★★★(\(book?.Items.first?.Item.reviewCount ?? 0))")
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
                        Text(book?.Items.first?.Item.itemCaption ?? "本の詳細がありません")
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
                path.removeLast()
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
            .padding(.bottom, 10)
            
            if !(isBorrowing ?? false) {
                Button {
                    if isLoading {
                        felicaReader.beginScanning()
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 280, height: 55)
                            .foregroundColor(isLoading ? .blue : .gray)
                            .cornerRadius(8.0)
                        Text("本を借りる")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 18.0))
                    }
                    .padding(.vertical)
                    .padding(.bottom, 10)
                }
                .onChange(of: felicaReader.idm) {
                    if !felicaReader.idm.isEmpty {
                        Task {
                            await bookViewModel.fetchStudentInfo(idm: felicaReader.idm)
                            isShowSheet.toggle()
                        }
                    }
                }
            } else {
                Button {
                    return
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 280, height: 55)
                            .cornerRadius(8.0)
                        Text("本を返す")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 18.0))
                    }
                    .padding(.vertical)
                    .padding(.bottom, 10)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .shadow(radius: 10)
        .ignoresSafeArea()
    }
}

