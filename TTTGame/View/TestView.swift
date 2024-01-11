//
//  TestView.swift
//  TTTGame
//
//  Created by Jay Jahanzad on 2024-01-08.
//

import SwiftUI

struct TestView: View {
    // MARK: - PROPS
    @State var isOn: Bool = false
    private var isAnimating: Bool = false {
        didSet {
            print("reset")
        }
    }
    
    
    
    var body: some View {
        Text(isOn ? "On" : "Off")
        
        
        Button(action: {
            isOn.toggle()
            
        }, label: {
            Text("Click")
        })
    }
}

var globalTestView = TestView()



func changeTestView() {
    globalTestView.isOn.toggle()
}

#Preview {
    TestView()
}
