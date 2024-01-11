//
//  ScoreView.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import SwiftUI

struct ScoreView: View {
	
	@ObservedObject var viewModel: GameViewModel
	
    var body: some View {
        HStack {
			Text("\(viewModel.player1Name): \(viewModel.player1Score)")
            Spacer()
			Text("\(viewModel.player2Name): \(viewModel.player2Score)")
            
            
        }
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding(.horizontal, 20)
    }
}

#Preview {
	ScoreView(viewModel: GameViewModel(with: .vsHuman))
        .background(.gray)
}
