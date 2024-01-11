//
//  Player.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-10.
//

import Foundation

/// We want it to be Codable so we can save these to Firebase later on
enum Player: Codable {
	case player1, player2, cpu
	
	var name: String {
		switch self {
		case .player1:
			return AppStrings.player1
		case .player2:
			return AppStrings.player2
		case .cpu:
			return AppStrings.computer
		}
	}
}
