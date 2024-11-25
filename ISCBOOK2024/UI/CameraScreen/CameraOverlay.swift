//
//  CameraOverlay.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/06.
//

import Foundation
import SwiftUI

struct CameraOverlay: View {
    
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    path.removeLast(path.count)
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.trailing, 2)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.leading)
                
                Spacer()
            }
            
            Image("Attention")
                .resizable()
                .frame(width: 350, height: 200)
                .cornerRadius(10.0)
                .padding()
                .opacity(0.85)
            
            Spacer()
                .frame(height: 50)
            
            Rectangle()
                .stroke(lineWidth: 4.0)
                .foregroundColor(.orange)
                .frame(width: 300, height: 150)
            
            Spacer()
        }
    }
}
