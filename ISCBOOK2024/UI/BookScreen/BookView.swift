//
//  BookView.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/08.
//

import SwiftUI

struct BookView: View {
    
    @StateObject var felicaReader = FelicaReader()
    @StateObject var bookViewModel = BookViewModel()
    
    @State private var showSheet: Bool = false
    @State private var isExpanded: Bool = false
    @State var isShowSheet: Bool = false
    @State var scannedCode: String?
    @State var isBorrowing: Bool
    
    @Binding var path: NavigationPath
    
    
    var body: some View {
        VStack {
            BookImageArea
                .onAppear {
                    if let code = scannedCode {
                        Task {
                            await bookViewModel.fetchBookDetail(isbn: code, isBorrowing: isBorrowing)
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
        .alert("この本は借りれません", isPresented: $bookViewModel.isShowAlert) {
            Button("OK") {
                path.removeLast()
            }
        } message: {
            Text("図書コーナーにある本を借りてください。")
        }
        .alert("この本は借りれません", isPresented: $bookViewModel.isBorrowAlert) {
            Button("OK") {
                path.removeLast(path.count)
            }
        } message: {
            Text("この本は現在貸し出し中になっています。返却を行なってください。")
        }
        .alert("この本は返せません", isPresented: $bookViewModel.isReturnAlert) {
            Button("OK") {
                path.removeLast(path.count)
            }
        } message: {
            Text("この本は現在貸し出し中になっていません。貸し出しを行なってください。")
        }
        .alert("貸し出し処理が完了しました", isPresented: $bookViewModel.isBorrowedSuccess) {
            Button("OK") {
                path.removeLast(path.count)
            }
        } message: {
            Text("返却期限は\(returnDate())です。返却期限までに返却してください。")
        }
        .alert("返却処理が完了しました", isPresented: $bookViewModel.isReturnSuccess) {
            Button("OK") {
                path.removeLast(path.count)
            }
        } message: {
            Text("もとあった位置に本を戻してください。")
        }
        .alert("もうすでに借りています", isPresented: $bookViewModel.isBorrowedAlert) {
            Button("OK") {
                path.removeLast(path.count)
            }
        } message: {
            Text("この本をすでに借りているようです。")
        }
        .alert("エラーが起きました", isPresented: $bookViewModel.isErrorAlert) {
            Button("OK") {
                path.removeLast(path.count)
            }
        } message: {
            Text("エラーが発生しました。")
        }
        .sheet(isPresented: $isShowSheet) {
            VStack {
                BorrowSheet(book: bookViewModel.book, isBorrowing: isBorrowing, isShowSheet: $isShowSheet, bookViewModel: bookViewModel, felicaReader: felicaReader)
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
                    if let imageUrlString = bookViewModel.bookItem?.largeImageUrl,
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
                    Text(bookViewModel.bookItem?.author ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .bold()
                    
                    Text(bookViewModel.bookItem?.title ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    
                    Spacer()
                        .frame(height: 10)
                    
                    switch bookViewModel.reviewAverageInt {
                    case 0:
                        Text("☆☆☆☆☆(\(bookViewModel.bookItem?.reviewCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical, 4)
                    case 1:
                        Text("★☆☆☆☆(\(bookViewModel.bookItem?.reviewCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical)
                    case 2:
                        Text("★★☆☆☆(\(bookViewModel.bookItem?.reviewCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical)
                    case 3:
                        Text("★★★☆☆(\(bookViewModel.bookItem?.reviewCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                    case 4:
                        Text("★★★★☆(\(bookViewModel.bookItem?.reviewCount ?? 0))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 15.0))
                            .padding(.vertical)
                    case 5:
                        Text("★★★★★(\(bookViewModel.bookItem?.reviewCount ?? 0))")
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
                        Text(bookViewModel.bookItem?.itemCaption ?? "本の詳細がありません")
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
            
            if isBorrowing {
                Button {
                    if bookViewModel.isLoading {
                        felicaReader.beginScanning()
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 280, height: 55)
                            .foregroundColor(bookViewModel.isLoading ? .blue : .gray)
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
                    if bookViewModel.isLoading {
                        felicaReader.beginScanning()
                    }
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
                .onChange(of: felicaReader.idm) {
                    if !felicaReader.idm.isEmpty {
                        Task {
                            await bookViewModel.fetchStudentInfo(idm: felicaReader.idm)
                            isShowSheet.toggle()
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .shadow(radius: 10)
        .ignoresSafeArea()
    }
    
    private func returnDate() -> String{
        let modifiedDate = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter.string(from: modifiedDate)
    }
}

