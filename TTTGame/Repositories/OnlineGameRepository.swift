//
//  OnlineGameRepository.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-11.
//

/*
 Join a game if there is one available, if there isn't, create a game and listen for changes
 
 1. IF: Created a game / waiting
 Block user moves
 Show "waiting" notification
 Sync local game with the online
 Scores are 0
 
 
 2. IF: Joined a game
 Put us as player2
 Block our move
 Show notification that game has started
 
 On each click, process the move locally, sync with online.
 
 3. IF: Game is over
 Update the score,
 Update the winnersId
 Show game over notification
 
 4. IF: Game is draw
 Update winnersId to 0
 Show game draw notification
 
 SYNC WITH ONLINE
 */

///Layer between online backend communication (Firebase) and our GameViewModel


import Foundation
import Combine
import Factory


let localPlayerId = UUID().uuidString


final class OnlineGameRepository: ObservableObject {
	// MARK: - PROPERTIES
	
	// Below we tell Factory whatever conforms to @Injected(\.firebaseRepository), please assign it to this variable name (here its firebaseRepository again)
	@Injected(\.firebaseRepository) private var firebaseRepository
	@Published var game: Game!
	
	private var cancellables: Set<AnyCancellable> = []
	
	// MARK: - FUNCTIONS
	
	
	// MARK: - Join Game Function
	@MainActor
	func joinGame() async {
		if let gamesToJoin: Game = await getGame() {
			
			self.game = gamesToJoin
			
			// this is setting us as the player 2
			self.game.player2Id = localPlayerId
			
			// want it to be player 1, the individual who is already there
			self.game.activePlayerId = self.game.player1Id
			
			await updateGame(self.game)
			
			await listenForChanges(in: self.game.id)
			
		} else {
			await createNewGame()
			await listenForChanges(in: self.game.id)
		}
	}
	
	// MARK: - Create New Game Function
	@MainActor
	private func createNewGame() async {
		self.game = Game(id: UUID().uuidString,
						 player1Id: localPlayerId,
						 player2Id: "",
						 player1Score: 0,
						 player2Score: 0,
						 activePlayerId: localPlayerId,
						 winningPlayerId: "",
						 moves: Array(repeating: nil, count: 9))
		
		await self.updateGame(self.game)
		
	}
	
	// MARK: - Listen for Changes Function
	@MainActor
	private func listenForChanges(in gameId: String) async {
		do {
			//Basically, we use combine below to subscribe to our Firebase listen function
			try await firebaseRepository.listen(from: .Game, documentId: gameId)
			// Everytime we receive some value, we sink it and inside our sink we get a completion
				.sink(receiveCompletion: { completion in
					switch completion {
					case .finished:
						return
					case .failure(let error):
						print("Error ", error.localizedDescription)
					}
					// and the receiveValue we get we are storing it to our game with self?.game
				}, receiveValue: { [weak self] game in
					self?.game = game
				})
				.store(in: &cancellables)
			
		} catch {
			print("Error listening... ", error.localizedDescription)
		}
	}
	
	
	// MARK: - Get Game Function
	// Optional Game return because there may be no games to return.
	private func getGame() async -> Game? {
		
		return try? await firebaseRepository.getDocuments(from: .Game, for: localPlayerId)?.first
	}
	
	
	// MARK: - Update Game Function
	func updateGame(_ game: Game) async {
		do {
			try firebaseRepository.saveDocument(data: game, to: .Game)
		} catch {
			print("Error updating online game", error.localizedDescription)
		}
	}
	
	// MARK: - Quit Game Function
	func quitGame() {
		guard game != nil else { return }
		firebaseRepository.deleteDocument(with: self.game.id, from: .Game)
	}
}
