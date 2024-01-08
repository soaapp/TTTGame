//
//  CustomButtonView.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import SwiftUI

struct CustomButtonView: View {
    
    @State private var isPresented = false
    var mode: GameMode
    
    var body: some View {
        ZStack {
            Button(action: {
                isPresented.toggle()
//                print(mode.self)
            }, label: {
                HStack {
                    Text(mode.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
            })
            .frame(maxWidth: .infinity)
            .padding(25)
            .background(mode.color)
            .clipShape(Capsule())
            .shadow(radius: 8)
        }
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $isPresented, content: {
            GameView(mode: mode.self)
        })
    }
}

#Preview {
    CustomButtonView(mode: .vsHuman)
}
