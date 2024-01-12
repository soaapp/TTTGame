//
//  TTTGameApp.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import SwiftUI
import Firebase

@main
struct TTTGameApp: App {
	
	init() {
		FirebaseApp.configure()
	}
	
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
