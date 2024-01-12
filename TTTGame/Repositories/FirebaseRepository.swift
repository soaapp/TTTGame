//
//  FirebaseRepository.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-10.
//

import Foundation
import FirebaseFirestoreSwift
import Combine

// All calls to Firebase are asynchronous btw

public typealias EncodableIdentifiable = Codable & Identifiable

protocol FirebaseRepositoryProtocol {
	/*
	 JJ's Notes:
	 We want to get docs with generic type but it has to be codable, and we pass playerId as string bc we want to get the game for that playerID.
	 Function is also async.
	 Function may also throw an error.
	 It returns an array of generic type Codable.
	*/
	func getDocuments<T: Codable>(from collection: FCCollectionReference, for playerId: String) async throws -> [T]?
	
	
	func listen<T: Codable>(from collection: FCCollectionReference, documentId: String) async throws -> AnyPublisher<T?, Error>
	
	/*
	 JJ's Notes:
	 Delete everything that matches this ID
	 */
	func deleteDocument(with id: String, from collection: FCCollectionReference)
	
	/*
	 JJ's Notes:
	 So we want to save our data with this one, but it is not just Codable its also Identifiable so we need to be able to know what we saved
	 */
	func saveDocument<T: EncodableIdentifiable>(data: T, to collection: FCCollectionReference) throws
}

final class FirebaseRepository: FirebaseRepositoryProtocol {
	
	func getDocuments<T: Codable>(from collection: FCCollectionReference, for playerId: String) async throws -> [T]? {
		// check if there are any active games where player2Id is not set, aka ""
		let snapshot = try await FirebaseReference(collection)
			.whereField(Constants.player2Id, isEqualTo: "")
			.whereField(Constants.player1Id, isNotEqualTo: playerId).getDocuments()
		
		
		return snapshot.documents.compactMap { queryDocumentSnapshot -> T? in
			return try? queryDocumentSnapshot.data(as: T.self)
		}
	}
	
	func listen<T: Codable>(from collection: FCCollectionReference, documentId: String) async throws -> AnyPublisher<T?, Error> {
		let subject = PassthroughSubject<T?, Error>()
		
		let handle = FirebaseReference(collection).document(documentId).addSnapshotListener { querySnapshot, error in
			if let error = error {
				subject.send(completion: .failure(error))
				return
			}
			
			guard let document = querySnapshot else {
				subject.send(completion: .failure(AppError.badSnapshot))
				return
			}
			
			let data = try? document.data(as: T.self)
			
			subject.send(data)
		}
		
		return subject.handleEvents(receiveCancel: {
			handle.remove()
		}).eraseToAnyPublisher()
	}
	
	func deleteDocument(with id: String, from collection: FCCollectionReference) {
		FirebaseReference(collection).document(id).delete()
	}
	
	func saveDocument<T: EncodableIdentifiable>(data: T, to collection: FCCollectionReference) throws {
		let id = data.id as? String ?? UUID().uuidString
		
		try FirebaseReference(collection).document(id).setData(from: data.self)
	}
	
	
}
