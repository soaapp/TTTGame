//
//  DismissButtonView.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import SwiftUI

struct DismissButtonView: View {
    var body: some View {

        Image(systemName: "xmark.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 40)
            .foregroundColor(.red)
    }
}

#Preview {
    DismissButtonView()
}
