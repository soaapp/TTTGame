//
//  FCCollectionReference.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-10.
//

import Foundation
import Firebase

enum FCCollectionReference: String {
	case Game
}

func FirebaseReference(_ reference: FCCollectionReference) -> CollectionReference {
	Firestore.firestore().collection(reference.rawValue)
}
