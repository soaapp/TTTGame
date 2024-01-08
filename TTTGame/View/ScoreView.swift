//
//  ScoreView.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import SwiftUI

struct ScoreView: View {
    var body: some View {
        HStack {
            Text("Player 1: 0")
            Spacer()
            Text("Player 2: 0")
            
            
        }
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ScoreView()
        .background(.gray)
}
