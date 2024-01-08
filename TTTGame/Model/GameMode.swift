//
//  GameMode.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import Foundation
import SwiftUI

enum GameMode: CaseIterable, Identifiable {
    
    var id: Self { return self }
    
    case vsHuman, vsCPU, online
    
    var name: String {
        switch self {
        case .vsHuman:
            return AppStrings.vsHuman
        case .vsCPU:
            return AppStrings.vsCpu
        case .online:
            return AppStrings.online
        }
    }
    
    var color: Color {
        switch self {
        case .vsHuman:
            return .indigo
        case .vsCPU:
            return .red
        case .online:
            return .green
        }
        
    }
    
}
