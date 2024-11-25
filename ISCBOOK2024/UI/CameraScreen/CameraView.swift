//
//  CameraView.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/06.
//

import SwiftUI

struct CameraView: View {
    
    @State private var scannedCode: String?
    @State var isBorrowing: Bool?
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            ScannerView(scannedCode: $scannedCode)
                .ignoresSafeArea()
                .onChange(of: scannedCode) {
                    if let code = scannedCode, code.starts(with: "978")  {
                        appendBookPath(code: code)
                        // appendAddBookPath(code: code)
                    }
                }
            CameraOverlay(path: $path)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func appendBookPath(code: String) {
        path.append(Destination.bookView(code: code, isBorrowing: isBorrowing))
    }
    
    private func appendAddBookPath(code: String) {
        path.append(Destination.addBookView(code: code))
    }
}

