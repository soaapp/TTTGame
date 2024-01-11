//
//  AlertItem.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-10.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
	let id = UUID()
	var title: Text
	var message: Text
	var buttonTitle: Text
	
	init(title: String, message: String, buttonTitle: String = AppStrings.rematch) {
		self.title = Text(title)
		self.message = Text(message)
		self.buttonTitle = Text(buttonTitle)
	}
}
