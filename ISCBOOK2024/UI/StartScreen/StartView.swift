//
//  StartView.swift
//  ISCBOOK2024
//
//  Created by Gomi Kouki on 2024/10/03.
//

import SwiftUI

struct StartView: View {
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                
                Spacer()
                
                LendingButton(geometry: geometry)
                
                ReturnButton(geometry: geometry)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    StartView()
}

extension StartView {
    
    func LendingButton(geometry: GeometryProxy) -> some View {
        Button(action: {
            return
        }, label: {
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
        })
        .padding()
    }
    
    func ReturnButton(geometry: GeometryProxy) -> some View {
        Button(action: {
            return
        }, label: {
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
        })
        .padding()
    }
}

