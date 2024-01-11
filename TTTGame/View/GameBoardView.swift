//
//  GameBoardView.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import SwiftUI

struct GameBoardView: View {
    
    var geometry: GeometryProxy
    var viewModel: GameViewModel
    
    @State var sizeDivider: CGFloat = 3
    @State var padding: CGFloat = 15
    
    var body: some View {
        VStack {
            LazyVGrid(columns: viewModel.columns, spacing: 10, content: {
                ForEach(0..<9) { index in
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: geometry.size.width / sizeDivider - padding,
                                   height: geometry.size.width / sizeDivider - padding)
						BoardIndicatorView(imageName: viewModel.moves[index]?.indicator ?? "")
                    }
					.onTapGesture {
						viewModel.processMove(for: index)
					}
                    
                }
                
            })
        }
        .padding()
		.disabled(viewModel.isGameBoardDisabled)
    }
}

//#Preview {
//    var viewModel = GameViewModel()
//    GeometryReader { geometry in
//        GameBoardView(geometry: geometry, viewModel: viewModel)
//    }
//    
//}
