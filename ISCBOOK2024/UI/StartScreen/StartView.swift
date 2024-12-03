//
//  StartView.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/03.
//

import SwiftUI

struct StartView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader{ geometry in
                VStack {
                    Spacer()
                    
                    Button {
                        path.append(Destination.lending)
                    } label: {
                        LendingButton(geometry: geometry)
                    }
                    
                    Button {
                        path.append(Destination.returning)
                    } label: {
                        ReturnButton(geometry: geometry)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .lending:
                    CameraView(isBorrowing: false, path: $path)
                case .returning:
                    CameraView(isBorrowing: true, path: $path)
                case .bookView(let code, let isBorrowing):
                    BookView(scannedCode: code, isBorrowing: isBorrowing, path: $path)
                case .addBookView(code: let code):
                    AddBookView(scannedCode: code, path: $path)
                }
            }
        }
    }
}

#Preview {
    StartView()
}

extension StartView {
    
    func LendingButton(geometry: GeometryProxy) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.red)
                .frame(width: geometry.size.width / 1.2, height: geometry.size.height / 2.5)
                .cornerRadius(10.0)
            Text("貸出")
                .foregroundColor(.white)
                .font(.system(size: 50))
                .bold()
        }
        .padding()
    }
    
    func ReturnButton(geometry: GeometryProxy) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: geometry.size.width / 1.2, height: geometry.size.height / 2.5)
                .cornerRadius(10.0)
            Text("返却")
                .foregroundColor(.white)
                .font(.system(size: 50))
                .bold()
        }
        .padding()
    }
}

