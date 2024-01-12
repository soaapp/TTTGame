//
//  OnlineGameTests.swift
//  TTTGameTests
//
//  Created by Jay Jahanzad on 2024-01-12.
//

import Foundation
import Factory
import Combine
import XCTest

@testable import TTTGame



final class OnlineGameTests: XCTestCase {
	
	private var cancellables: Set<AnyCancellable> = []
	
	func test_JoinGameReturnsReadyGame() async throws {
		Container.setupMocks()
		let sut = OnlineGameRepository()
		
		sut.$game
			.dropFirst()
			.sink { newValue in
				XCTAssertEqual(newValue?.id, "MockId")
				XCTAssertEqual(newValue?.player1Id, "P1ID")
			}
			.store(in: &cancellables)
		
		await sut.joinGame()
	}
	
	func test_JoinGame() async throws {
		
		Container.setupMocks(shouldReturnNil: true)
		
		let sut = OnlineGameRepository()
		
		sut.$game
			.dropFirst()
			.sink { newValue in
				XCTAssertEqual(newValue?.player2Id, "")
			}
			.store(in: &cancellables)
		
		await sut.joinGame()
	}
	
}

