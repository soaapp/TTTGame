//
//  ContentView.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import SwiftUI

struct HomeView: View {
    // MARK: - PROPERTIES
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 15) {
            VStack(alignment: .center) {
                Image(systemName:"number")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
                    
                
                Text("Tic Tac Toe")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
            }
            .foregroundColor(.indigo)
            
            Spacer()
            
            CustomButtonView(mode: .vsHuman)
            CustomButtonView(mode: .vsCPU)
            CustomButtonView(mode: .online)
            
            
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
