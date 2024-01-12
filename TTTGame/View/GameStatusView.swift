//
//  GameStatusView.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import SwiftUI

struct GameStatusView: View {
	
	@ObservedObject var viewModel: GameViewModel
	
    var body: some View {
		Text(viewModel.gameNotification)
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(.white)
		if viewModel.showLoading {
			ProgressView()
				.progressViewStyle(.circular)
				.tint(.white)
		}
    }
}

#Preview {
	GameStatusView(viewModel: GameViewModel(with: .vsCPU, onlineGameRepository: OnlineGameRepository()))
        .background(.gray)
}
