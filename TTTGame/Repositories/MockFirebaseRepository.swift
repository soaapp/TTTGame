//
//  MockFirebaseRepository.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-12.
//

import Foundation
import FirebaseFirestoreSwift
import Combine


final class MockFirebaseRepository: FirebaseRepositoryProtocol {
	
	let dummyGame = Game(id: "MockId",
						 player1Id: "P1ID",
						 player2Id: "P2ID",
						 player1Score: 3,
						 player2Score: 4,
						 activePlayerId: "P1ID",
						 winningPlayerId: "",
						 moves: Array(repeating: nil, count: 9))
	
	var returnNil = false
	
	init(shouldReturnNil: Bool = false) {
		returnNil = shouldReturnNil
	}
	
	func getDocuments<T>(from collection: FCCollectionReference, for playerId: String) async throws -> [T]? where T : Decodable, T : Encodable {
		
		return returnNil ? nil : [dummyGame] as? [T]
	}
	
	func listen<T>(from collection: FCCollectionReference, documentId: String) async throws -> AnyPublisher<T?, Error> where T : Decodable, T : Encodable {
		let subject = PassthroughSubject<T?, Error>()
		
		subject.send(dummyGame as? T)
		return subject.eraseToAnyPublisher()
	}
	
	func deleteDocument(with id: String, from collection: FCCollectionReference) {
		<#code#>
	}
	
	func saveDocument<T>(data: T, to collection: FCCollectionReference) throws where T : Decodable, T : Encodable, T : Identifiable {
		<#code#>
	}
	
	
}
