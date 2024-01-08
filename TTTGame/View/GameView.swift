//
//  GameView.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import SwiftUI

struct GameView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    
    var mode: GameMode
    var viewModel = GameViewModel()
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                HStack{
                    Spacer()
                    DismissButtonView()
                        .onTapGesture {
                            dismiss()
                        }
                }
                .padding(.horizontal, 20)
                /// View that shows both Players' scores
                ScoreView()
                Spacer()
                
                /// View that shows the current game status. E.g. "Player 1's turn"
                GameStatusView()
                Text(mode.name)
                Spacer()
                

                    GameBoardView(geometry: geometry, viewModel: viewModel)
            }
            .background(.indigo)
        }
        
    }
}

#Preview {
    GameView(mode: .online)
        .background(.indigo)
}
