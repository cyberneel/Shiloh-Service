//
//  WeedWhacker.swift
//  Shiloh Service
//
//  Created by Neelesh Chevuri on 2/19/25.
//

import SwiftUI

struct Weed: Identifiable {
    let id = UUID()
    var position: CGPoint
}

struct WeedWhacker: View {
    @State private var weeds: [Weed] = []
    @State private var score = 0
    @State private var timeRemaining = 22
    @State private var gameOver = false
    @State private var gameStarted = false
    private let requiredScore = 20
    
    @State private var moveOn = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        if !moveOn {
            ZStack {
                Image("pixel-garden-color-soil")
                    .offset(x: 0, y: -25)
                    .scaleEffect(CGSize(width: 1.4, height: 1.4))
                
                if !gameStarted && !gameOver {
                    VStack {
                        Text("Weed Whacker!")
                            .font(
                                .system(size: 64, weight: .bold, design: .rounded)
                            )
                            .foregroundColor(.white)
                            .bold()
                        Text("Click on \(requiredScore) weeds before time runs out!")
                            .font(
                                .system(size: 32, weight: .bold, design: .rounded)
                            )
                            .foregroundColor(.white)
                        Button(action: {
                            withAnimation {
                                startGame()
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
                } else if gameOver {
                    VStack {
                        Text(score >= requiredScore ? "You Win!" : "Game Over")
                            .font(
                                .system(size: 64, weight: .bold, design: .rounded)
                            )
                            .foregroundColor(.white)
                            .bold()
                        Text("Score: \(score)")
                            .font(
                                .system(size: 32, weight: .bold, design: .rounded)
                            )
                            .foregroundColor(.white)
                        Button(action: {
                            withAnimation {
                                startGame()
                            }
                        }) {
                            Text("Play Again")
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
                        Button(action: {
                            print("Move to next scene")
                            withAnimation {
                                moveOn = true
                            }
                        }) {
                            Text("Next")
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 240, height: 120)
                                .background(Color.blue)
                                .cornerRadius(32)
                        }.contentShape(Rectangle())
                            .frame(width: 240 * 0.8, height: 120 * 0.8)  // Ensures tappable area matches visual size
                            .offset(x: 450, y: 200)  // Adjust button position instead of `position()`
                    }
                } else {
                    VStack {
                        Text("Time: \(timeRemaining)")
                            .font(
                                .system(size: 64, weight: .bold, design: .rounded)
                            )
                            .foregroundColor(.white)
                        Text("Score: \(score)")
                            .font(
                                .system(size: 64, weight: .bold, design: .rounded)
                            )
                            .foregroundColor(.white)
                    }.padding().background(Color.black.opacity(0.5))
                        .cornerRadius(32)
                        .offset(x: 0, y: -300)
                    
                    
                    ForEach(weeds) { weed in
                        Image("pixel-weed")
                            .interpolation(.none)
                            .scaleEffect(CGSize(width: 5, height: 5))
                            .offset(x: weed.position.x, y: weed.position.y)
                            .onTapGesture {
                                whackWeed(weed)
                            }
                    }
                }
            }
            .onReceive(timer) { _ in
                if gameStarted && !gameOver {
                    timeRemaining -= 1
                    if timeRemaining <= 0 {
                        endGame()
                    } else if timeRemaining >= 2 {
                        addWeed()
                    }
                }
            }
        } else {
            Scene4().transition(.blurReplace)
        }
    }
    
    func startGame() {
        score = 0
        timeRemaining = 22
        weeds.removeAll()
        gameStarted = true
        gameOver = false
    }
    
    func addWeed() {
        let newWeed = Weed(position: CGPoint(x: CGFloat.random(in: -150...150), y: CGFloat.random(in: -50...50)))
        
        weeds.append(newWeed)
    }
    
    func whackWeed(_ weed: Weed) {
        weeds.removeAll { $0.id == weed.id }
        score += 1
    }
    
    func endGame() {
        gameOver = true
        gameStarted = false
    }
}

struct WeedWhackerView_Previews: PreviewProvider {
    static var previews: some View {
        WeedWhacker()
    }
}
