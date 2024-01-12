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
    
//	Getting it from somewhere else not creating it
    @ObservedObject var viewModel: GameViewModel
    
//    var viewModel = GameViewModel()
    
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                HStack{
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .dismissImageModifier()
                        .onTapGesture {
							viewModel.quitTheGame()
                            dismiss()
                        }
                }
                .padding(.horizontal, 20)
                /// View that shows both Players' scores
				ScoreView(viewModel: viewModel)
                Spacer()
                
                /// View that shows the current game status. E.g. "Player 1's turn"
				GameStatusView(viewModel: viewModel)
                Spacer()
                

                    GameBoardView(geometry: geometry, viewModel: viewModel)
            }
            .background(.indigo)
			.alert(isPresented: $viewModel.showAlert, content: {
				Alert(title: viewModel.alertItem!.title, 
					  message: viewModel.alertItem!.message,
					  dismissButton: .default(viewModel.alertItem!.buttonTitle) {
					viewModel.resetGame()
				})
			})
        }
        
    }
}

extension Image {
	
	///Image modifier for dismiss button inside GameView
	func dismissImageModifier() -> some View {
		self
			.resizable()
			.scaledToFit()
			.frame(width: 40)
			.foregroundColor(.red)
	}
}


///Previous way Andrew and I tried to do the image modifier.
//fileprivate struct MyImageModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        content
////            .resizable()
//            .scaledToFit()
//            .frame(width: 40)
////            .foregroundColor(.red)
//        
//    }
//     
//    
//}

#Preview {
	GameView(viewModel: GameViewModel(with: .vsHuman))
        .background(.indigo)
}
