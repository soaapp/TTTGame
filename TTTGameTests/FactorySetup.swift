//
//  FactorySetup.swift
//  TTTGameTests
//
//  Created by Jay Jahanzad on 2024-01-12.
//

import Foundation
import Factory

@testable import TTTGame

extension Container {
	
	static func setupMocks(shouldReturnNil: Bool = false) {
		Container.shared.firebaseRepository.register {
			MockFirebaseRepository(shouldReturnNil: shouldReturnNil)
		}
	}
}
