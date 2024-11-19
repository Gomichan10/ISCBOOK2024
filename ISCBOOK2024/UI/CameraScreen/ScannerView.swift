//
//  BarcodeScannerView.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/06.
//

import Foundation
import SwiftUI
import AVFoundation

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode: String?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(scannedCode: $scannedCode)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = ScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        @Binding var scannedCode: String?
        
        init(scannedCode: Binding<String?>) {
            _scannedCode = scannedCode
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                if let stringValue = readableObject.stringValue {
                    scannedCode = stringValue
                }
            }
        }
    }
}
