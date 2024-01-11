//
//  Game.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-10.
//

import Foundation

struct Game: Codable, Identifiable {
	let id: String
	
	var player1Id: String
	var player2Id: String
	
	var player1Score: Int
	var player2Score: Int
	
	var activePlayerId: String
	var winningPlayerId: String
	
	var moves: [GameMove?]
}
