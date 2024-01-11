//
//  GameState.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-10.
//

import Foundation

enum GameState {
	case finished, draw, waitingForPlayer, quit
	
	var name: String {
		switch self {
		case .finished:
			return AppStrings.gameHasFinished
		case .draw:
			return AppStrings.gameHasDraw
		case .waitingForPlayer:
			return AppStrings.waitingForPlayer
		case .quit:
			return AppStrings.gameQuit
		}
	}
}
