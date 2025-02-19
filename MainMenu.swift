//
//  MainMenu.swift
//  Shiloh Service
//
//  Created by Neelesh Chevuri on 2/17/25.
//

import SwiftUI
import SpriteKit // If you are using SpriteKit for your game scene

struct MainMenuView: View {
    @State private var isPlaying = false
    
    var body: some View {
        if isPlaying == false {
            ZStack {
                // Background Color (Soft Sky Blue)
                Color(#colorLiteral(red: 0.679265976, green: 0.8443796039, blue: 0.5737109184, alpha: 1))
                    .opacity(1)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 30) {
                    // Cloud-Like Title
                    Text("Shiloh Service")
                        .font(.system(size: 50, weight: .heavy, design: .rounded)) // Soft rounded font
                        .foregroundColor(.white)
                        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 4) // Adds floating effect
                    
                    // Play Button
                    Button(action: {
                        withAnimation {
                            isPlaying = true
                        }
                    }) {
                        Text("Play")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 55)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.green, Color.mint]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(15)
                            .shadow(radius: 8) // Soft glow effect
                    }
                    .buttonStyle(PlainButtonStyle()) // Removes default styling
                }
            }
        } else {
            Scene1().transition(.blurReplace).frame(width: 1250, height: 820)
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
