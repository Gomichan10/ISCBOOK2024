//
//  FelicaScanView.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/18.
//

import SwiftUI
import CoreNFC

struct FelicaScanView: View {
    @StateObject private var felicaReader = FelicaReaderViewController()
    
    var body: some View {
        VStack {
            // FelicaタグのIDmとSystemCodeを表示
            if !felicaReader.idm.isEmpty {
                Text("IDm: \(felicaReader.idm)")
                Text("System Code: \(felicaReader.systemCode)")
            } else {
                Text("Felicaカードをスキャンしてください")
                    .padding()
            }
            
            // スキャンを開始するボタン
            Button(action: {
                felicaReader.beginScanning()
            }) {
                Text("スキャン開始")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            if !NFCTagReaderSession.readingAvailable {
                print("このデバイスはNFCをサポートしていません")
            }
        }
    }
}

#Preview {
    FelicaScanView()
}
