//
//  ServiceDependencies.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-11.
//

import Foundation
import Factory

extension Container {
	
	var firebaseRepository: Factory<FirebaseRepositoryProtocol> {
		self { FirebaseRepository() }
			.shared
	}
}
