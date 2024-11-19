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
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if let code = scannedCode, code.starts(with: "978")  {
                BookView(scannedCode: $scannedCode, isBorrowing: $isBorrowing)
                // AddBookView(scannedCode: $scannedCode)
            } else {
                ScannerView(scannedCode: $scannedCode)
                    .ignoresSafeArea()
                CameraOverlay {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CameraView()
}
