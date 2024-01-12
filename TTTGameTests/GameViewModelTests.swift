//
//  TTTGameTests.swift
//  TTTGameTests
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import XCTest
@testable import TTTGame

final class TTTGameTests: XCTestCase {

	//SUT stands for system under test
	var sut = GameViewModel(with: .vsHuman, onlineGameRepository: OnlineGameRepository())
	
	//For each test we are gonna write a function, but the test functions have one thing that differentiate them, they start with test word
	func test_ResetGameSetsTheActivePlayerToPlayer1() {
		sut.resetGame()
		XCTAssertEqual(sut.activePlayer, .player1)
	}
	
	func test_ResetGameSetsMovesToNineNilObjects() {
		sut.resetGame()
		XCTAssertEqual(sut.moves.count, 9)
	}
	
	func test_ResetGameSetsGameNotificationToP1Turn() {
		sut.resetGame()
		XCTAssertEqual(sut.gameNotification, "It's \(sut.activePlayer.name)'s move.")
	}
	
	func test_ProcessMovesWillShowFinishAlert() {
		for index in 0..<9 {
			sut.processMove(for: index)
		}
		
		XCTAssertEqual(sut.gameNotification, AppStrings.gameHasFinished)
	}
	
	func test_ProcessMovesWillReturnForOccupiedSquare() {
		sut.processMove(for: 0)
		sut.processMove(for: 0)
		
		XCTAssertEqual(sut.moves.compactMap {$0}.count, 1)
	}
	
	//MARK: Helper Function: Player 1 Wins
	func player1WillWin() {
		//P1 wins with [0, 1, 2]
		sut.processMove(for: 0) //P1
		sut.processMove(for: 3) //P2
		sut.processMove(for: 1) //Keeps alternating
		sut.processMove(for: 4)
		sut.processMove(for: 2)
	}
	
	//MARK: Helper Function: Player 2 Wins
	func player2WillWin() {
		//P2 wins with [0, 1, 2]
		sut.processMove(for: 3) //P1
		sut.processMove(for: 0) //P2
		sut.processMove(for: 5) //Keeps alternating
		sut.processMove(for: 1)
		sut.processMove(for: 8)
		sut.processMove(for: 2)
	}
	
	//MARK: Helper Function: Draw
	func produceDraw() {
		//Draw
		sut.processMove(for: 4) //P1
		sut.processMove(for: 6) //P2
		sut.processMove(for: 7) //Keeps alternating
		sut.processMove(for: 1)
		sut.processMove(for: 2)
		sut.processMove(for: 8)
		sut.processMove(for: 5)
		sut.processMove(for: 3)
		sut.processMove(for: 0)
	}
	
	func test_Player1WinWillIncreaseTheScore() {
		XCTAssertEqual(sut.player1Score, 0)
		player1WillWin()
		XCTAssertEqual(sut.player1Score, 1)
		
	}
	
	func test_Player2WinWillIncreaseTheScore() {
		XCTAssertEqual(sut.player2Score, 0)
		player2WillWin()
		XCTAssertEqual(sut.player2Score, 1)
		
	}
	
	// MARK: - Test for PRIVATE Function (checkForDraw())
	func test_DrawWillShowNotification() {
		produceDraw()
		XCTAssertEqual(sut.gameNotification, GameState.draw.name)
		
	}
	
	//MARK: Test for ASYNC Function
	func test_CPUWillTakeCenterSquare() {
		//So first we need to wait for our CPU to make its move after 0.9 seconds otherwise this test would fail
		let expectation = expectation(description: "Waiting for CPU to make its move.")
		
		//We also have set SUT to be .vsHuman, here we need .vsCPU
		
		sut = GameViewModel(with: .vsCPU, onlineGameRepository: OnlineGameRepository())
		
		//Take the necessary spots for this test
		sut.processMove(for: 0) //P1
		
		//The CPU after just this one move should pick the middle square, we just need to wait a bit after the CPU's wait time
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
			XCTAssertNotNil(self.sut.moves[4])
			expectation.fulfill()
		})
		
		waitForExpectations(timeout: 1.1)
		
		
		
	}
	
	
	
	

}
