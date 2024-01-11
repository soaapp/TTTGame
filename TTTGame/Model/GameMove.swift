//
//  GameMove.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-10.
//

import Foundation

struct GameMove: Codable {
	let player: Player
	let boardIndex: Int
	
	var indicator: String {
		player == .player1 ? "xmark" : "circle"
	}
}
