//
//  GameViewModel.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import Foundation
import SwiftUI

// Its a final class bc we are not gonna inherit or change this class
final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
}
