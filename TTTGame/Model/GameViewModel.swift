//
//  GameViewModel.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import Foundation
import SwiftUI
import Combine


// Its a final class bc we are not gonna inherit or change this class
final class GameViewModel: ObservableObject {
	
	let onlineRepository: OnlineGameRepository
	
	// MARK: - Tic Tac Toe Grid Columns
	let columns: [GridItem] = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	// MARK: - Win Patterns
	private let winPatterns: Set<Set<Int>> = [
		/// Horizontal
		[0, 1, 2],
		[3, 4, 5],
		[6, 7, 8],
		
		/// Vertical
		[0, 3, 6],
		[1, 4, 7],
		[2, 5, 8],
		
		/// Diagonal
		[0, 4, 8],
		[2, 4, 6],
	]
	
	// MARK: - Properties
	//	No one from outside can set this, thats why its private
	@Published private var gameMode: GameMode
	@Published private var players: [Player]
	
	/// Player variables
	@Published private(set) var moves: [GameMove?] = Array(repeating: nil, count: 9)
	@Published private(set) var player1Score = 0
	@Published private(set) var player2Score = 0
	@Published private(set) var player1Name = ""
	@Published private(set) var player2Name = ""
	@Published private(set) var activePlayer: Player = .player1
	@Published private(set) var alertItem: AlertItem?
	// We need isGameBoardDisabled cause in that time we wait, we can actually put in a value before CPU or before Online Opponent
	@Published private(set) var isGameBoardDisabled = false
	//Online game below:
	@Published private(set) var onlineGame: Game?
	@Published private(set) var showLoading: Bool = false
	
	private var cancellables: Set<AnyCancellable> = []

	
	@Published private(set) var gameNotification = ""
	
	@Published var showAlert = false
	
	
	
	// MARK: - Initializer for GameMode
	init(with gameMode: GameMode, onlineGameRepository: OnlineGameRepository) {
		self.gameMode = gameMode
		self.onlineRepository = onlineGameRepository
		
		switch gameMode{
		case .vsHuman:
			self.players = [.player1, .player2]
		case .vsCPU:
			self.players = [.player1, .cpu]
		case .online:
			self.players = [.player1, .player2]
			startOnlineGame()
		}
		
		gameNotification = "It's \(activePlayer.name)'s move."
		observeData()
	}
	
	private func observeData() {
		$players
			.map { $0.first?.name ?? "" }
			.assign(to: &$player1Name)
		
		$players
			.map { $0.last?.name ?? "" }
			.assign(to: &$player2Name)
		
		//In order to subscribe to it, we get the onlineRepository to map the value to game, so we can update our local game when changes are made to the onlineRepository
		onlineRepository.$game
			.map { $0 }
		//Holy crap what is happening below?
			.assign(to: &$onlineGame)
		
		$onlineGame
			.map { $0?.moves ?? Array(repeating: nil, count: 9) }
			.assign(to: &$moves)
		
		$onlineGame
			.map { $0?.player1Score ?? 0 }
			.assign(to: &$player1Score)
		
		$onlineGame
			.map { $0?.player2Score ?? 0 }
			.assign(to: &$player2Score)
		
		$onlineGame
			.drop(while: { $0 == nil })
			.map { $0?.player2Id == "" }
			.assign(to: &$showLoading)
		
		$onlineGame
			.drop(while: { $0 == nil })
			.sink { updatedGame in
				self.syncOnlineWithLocal(onlineGame: updatedGame)
			}
			.store(in: &cancellables)
		
		
		gameNotification = AppStrings.waitingForPlayer
		
	}
	
	private func syncOnlineWithLocal(onlineGame: Game?) {
		guard let game = onlineGame else {
			//show alert that other player has left
//			print("The game is nil")
			showAlert(for: .quit)
			return
		}
		
		if game.winningPlayerId == "0" {
			//Draw
			self.showAlert(for: .draw)
			//Show alert
		} else if game.winningPlayerId != "" {
			self.showAlert(for: .finished)
			//Win registered
			//Show alert
		}
		
		//Set disabled state
		isGameBoardDisabled = game.player2Id == "" ? true : localPlayerId != game.activePlayerId
		
		//Set active player
		setActivePlayerAndNotification(from: game)
		
		//Set notification status
		if game.player2Id == "" {
			gameNotification = AppStrings.waitingForPlayer
		}
	}
	
	// MARK: - Set Active Player and Notification Function
	private func setActivePlayerAndNotification(from game: Game) {
		if localPlayerId == game.player1Id {
			//We are player 1
			if localPlayerId == game.activePlayerId {
				self.activePlayer = .player1
				//Notification
				gameNotification = AppStrings.yourMove
			} else {
				//Notification update
				gameNotification = "It's \(activePlayer.name)'s move!"
			}
		} else {
			//We are player 2
			if localPlayerId == game.activePlayerId {
				self.activePlayer = .player2
				gameNotification = AppStrings.yourMove
			} else {
				gameNotification = "It's \(activePlayer.name)'s move!"
			}
			
		}
	}
	
	// MARK: - Start Online Game Function
	private func startOnlineGame() {
		//we put it in a TASK because joinGame() is async function but startOnlineGame() isnt
		Task {
			await onlineRepository.joinGame()
		}
	}
	
	// MARK: - Process Move Function
	/// Jan 10 Debug: This wasn't working when you change the activePlayer BEFORE you check for a win or draw! It must be checked before you change the activePlayer
	func processMove(for position: Int) {
		/// Check if position occupied?
		if isSquareOccupied(in: moves, for: position) { return }
		
		moves[position] = GameMove(player: activePlayer, boardIndex: position)
		
		/// Check for win
		if checkForWin(in: moves) {
			//show alert to user, for finished state
			showAlert(for: .finished)
			//increase score of winner
			increaseScore()
			//Update online game
			updateOnlineGame(process: .win)
			print("\(activePlayer) is victorious!")
			
			
			return
		}
		
		/// Check for draw
		if checkForDraw(in: moves) {
			showAlert(for: .draw)
			//Update online game
			updateOnlineGame(process: .draw)
			print("Its a draw.")
			return
		}
		
		// players array always has 2 values inside so if its not the current one ($0) its the second one
		/// Take position for that active player
		activePlayer = players.first(where: { $0 != activePlayer })!
		
		// Only call this if we are playing against CPU and its the CPU's turn
		if gameMode == .vsCPU && activePlayer == .cpu {
			//CPU should make a move
			isGameBoardDisabled = true
			computerMove()
		}
		
		//Update online game
		updateOnlineGame(process: .move)
		gameNotification = "It's \(activePlayer.name)'s move."
	}
	
	
	// MARK: - Update Online Game Function
	private func updateOnlineGame(process: GameProcess) {
		guard var tempGame = onlineGame else {
			return
		}
		isGameBoardDisabled = localPlayerId != tempGame.activePlayerId
		
		tempGame.activePlayerId = tempGame.activePlayerId == tempGame.player1Id ? tempGame.player2Id : tempGame.player1Id
		
		tempGame.player1Score = player1Score
		tempGame.player2Score = player2Score
		
		switch process {
		case .win:
			tempGame.winningPlayerId = localPlayerId
		case .draw:
			tempGame.winningPlayerId = "0"
			tempGame.activePlayerId = tempGame.player1Id
		case .reset:
			tempGame.winningPlayerId = ""
			tempGame.activePlayerId = tempGame.player1Id
		case .move:
			break
		}
		
		tempGame.moves = moves
		
		let gameToSave = tempGame
		
		// We are creating Task bc we are not in async function but we want to access online repo
		Task {
			await onlineRepository.updateGame(gameToSave)
		}
	}
	
	// MARK: - Computer Move
	private func computerMove() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { [self] in
			//1. Get position for CPU & 2. Process move
			processMove(for: getAIMovePosition(in: moves))
			isGameBoardDisabled = false
		}
	}
	
	// MARK: - CPU: Get AI Move Position
	private func getAIMovePosition(in moves: [GameMove?]) -> Int {
		let centerSquare = 4
		
		///MARK: 1. If we can win, take that index
		// We use .compactMap so we can get rid of nil values, then filter that .compactMap to get only moves that is the CPU's
		let computerMoves = moves.compactMap { $0 }.filter { $0.player == .cpu }
		// Again, we are just getting the
		let computerPositions = Set(computerMoves.map { $0.boardIndex })
		
		if let position = getTheWinningSpot(for: computerPositions){
			return position
		}
		
		
		
		///MARK: 2. If we can't win, check if the other player can win - Block the player
		// Same exact logic from above, but now we check it for the human so we can take that spot.
		let humanMoves = moves.compactMap { $0 }.filter { $0.player == .player1 }
		let humanPositions = Set(humanMoves.map { $0.boardIndex })
		
		if let position = getTheWinningSpot(for: humanPositions) {
			return position
		}
		
		
		///MARK: 3. Check if we can take the middle
		if !isSquareOccupied(in: moves, for: centerSquare) { return centerSquare }
		
		//MARK: 4. Take random index from available spots
		var movePosition = Int.random(in: 0..<9)
		while isSquareOccupied(in: moves, for: movePosition) {
			movePosition = Int.random(in: 0..<9)
		}
		return movePosition
	}
	
	// MARK: - CPU: Get Winning Spot
	private func getTheWinningSpot(for positions: Set<Int>) -> Int? {
		for pattern in winPatterns {
			let winPositions = pattern.subtracting(positions)
			
			// If there is only 1 spot left for a win condition and its an empty spot, take it!
			if winPositions.count == 1 && !isSquareOccupied(in: moves, for: winPositions.first!) {
				return winPositions.first!
			}
		}
		
		return nil
	}
	
	// MARK: - Is Square Occupied Function
	private func isSquareOccupied(in moves: [GameMove?], for index: Int) -> Bool {
		moves.contains(where: { $0?.boardIndex == index })
	}
	
	// MARK: - Check For Draw
	private func checkForDraw(in moves: [GameMove?]) -> Bool {
		moves.compactMap { $0 }.count == 9
	}
	
	// MARK: - Check For Win
	private func checkForWin(in moves: [GameMove?]) -> Bool {
		/// You have a win if you do, 3 in a row horizontally (E.g. 0, 1, 2), 3 in a row vertically (E.g. 0, 3, 6), or 3 diagonally (E.g. 0, 4, 8)
//		[0, 1, 2,
//		 3, 4, 5,
//		 6, 7, 8]
		let playerMoves = moves.compactMap { $0 }.filter { $0.player == activePlayer }
		let playerPositions = Set(playerMoves.map { $0.boardIndex })
		
		for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
			return true
		}
		return false
		
	}
	
	// MARK: - Increase Score
	private func increaseScore() {
		if activePlayer == .player1 {
			player1Score += 1
		} else {
			player2Score += 1
		}
	}
	
	// MARK: - Show Alert
	private func showAlert(for state: GameState) {
		gameNotification = state.name
		
		switch state {
		case .finished, .waitingForPlayer:
			let title = (state == .finished) ? "\(activePlayer.name) has won." : state.name
			alertItem = AlertItem(title: title, message: AppStrings.tryRematch)
		case .draw:
			let title = state.name
			alertItem = AlertItem(title: title, message: AppStrings.gameHasDraw)
		case .quit:
			let title = state.name
			alertItem = AlertItem(title: title, message: "", buttonTitle: "OK")
			isGameBoardDisabled = true
		}
		
		showAlert = true
	}
	
	// MARK: - Reset Game
	func resetGame() {
		activePlayer = .player1
		moves = Array(repeating: nil, count: 9)
		
		if gameMode == .online {
			updateOnlineGame(process: .reset)
		} else {
			gameNotification = "It's \(activePlayer.name)'s move."
		}
		
	}
	
	func quitTheGame() {
		onlineRepository.quitGame()
	}
	
}

