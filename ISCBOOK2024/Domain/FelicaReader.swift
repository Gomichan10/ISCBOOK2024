//
//  FelicaReaderViewController.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/13.
//

import Foundation
import CoreNFC

final class FelicaReader: NSObject, ObservableObject, NFCTagReaderSessionDelegate {
    
    @Published var idm: String = ""
    @Published var systemCode: String = ""
    @Published var isScanning: Bool = false
    
    private var session: NFCTagReaderSession?
    
    // スキャン開始メソッド
    func beginScanning() {
        guard NFCTagReaderSession.readingAvailable else {
            print("このデバイスはNFCをサポートしていません")
            return
        }
        
        print("NFCが有効です。スキャンを開始します。")
        isScanning = true
        
        // Felicaタグ用のセッションを開始
        session = NFCTagReaderSession(pollingOption: .iso18092, delegate: self, queue: nil)
        session?.alertMessage = "入校証をスキャンしてください"
        session?.begin()
    }
    
    // セッションがアクティブになると呼ばれる
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("NFCスキャンが開始されました")
    }
    
    // タグが検出されたときに呼ばれる
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("タグが検出されました")
        
        guard let firstTag = tags.first else {
            print("エラー: タグが見つかりませんでした")
            session.invalidate(errorMessage: "タグが見つかりませんでした")
            return
        }
        
        session.connect(to: firstTag) { (error: Error?) in
            if let error = error {
                print("接続エラー: \(error.localizedDescription)")
                session.invalidate(errorMessage: "接続中にエラーが発生しました: \(error.localizedDescription)")
                return
            }
            
            // Felicaタグか確認
            if case let .feliCa(felicaTag) = firstTag {
                print("Felicaタグが検出されました")
                let idm = felicaTag.currentIDm.map { String(format: "%.2hhx", $0) }.joined()
                let systemCode = felicaTag.currentSystemCode.map { String(format: "%.2hhx", $0) }.joined()
                
                print("IDm: \(idm), System Code: \(systemCode)")
                
                // メインスレッドでUIを更新
                DispatchQueue.main.async {
                    self.idm = idm
                    self.systemCode = systemCode
                    self.isScanning = false
                }
                
                session.invalidate()
            } else {
                print("エラー: Felicaタグが検出されませんでした")
                session.invalidate(errorMessage: "Felicaタグが検出されませんでした")
            }
        }
    }
    
    // セッションが無効になったときに呼ばれる
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("NFCスキャンが無効になりました: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.isScanning = false
        }
    }
}
