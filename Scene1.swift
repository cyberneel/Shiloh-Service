//
//  Scene1.swift
//  Shiloh Service
//
//  Created by Neelesh Chevuri on 2/17/25.
//

import AVFoundation
import SwiftUI

var audioPlayer: AVAudioPlayer?

struct Scene1: View {
    let storyChunks = [
        "Hey there!",
        "My name is Neelesh Chevuri.",
        "It is Saturday morning and I am currently in my dorm.",
        "You find yourself in a mysterious land, surrounded by towering trees.",
        "A faint whisper calls your name from the shadows...",
    ]

    @State private var currentChunkIndex = 0
    @State private var displayedText = ""
    @State private var charIndex = 0
    @State private var timer: Timer?
    @State private var isTypingDone = false

    var body: some View {
        ZStack {
            Color(
                #colorLiteral(red: 0.679, green: 0.844, blue: 0.573, alpha: 1)
            )
            .ignoresSafeArea()

            Image("pixel-dorm")
                .position(CGPoint(x: 775, y: 400))
                .scaleEffect(CGSize(width: 1.2, height: 1.2))

            Image("pixel-dorm-floor-oval")
                .scaleEffect(CGSize(width: 3.5, height: 3))
                .position(CGPoint(x: 220, y: 720))

            VStack {
                Image("cyberneel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500, height: 500)
                    .position(CGPoint(x: 220, y: 580))
                    .overlay(
                        Ellipse()
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 120, height: 30)
                            .offset(x: -405, y: 600)
                            .blur(radius: 5)
                    )

                Text(displayedText)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .multilineTextAlignment(.leading)
                    .frame(width: 350, height: 200)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(32)
                    .transition(.opacity)
                    .padding()
                    .position(CGPoint(x: 220, y: 55))

                Button(action: nextChunk) {
                    Text("Next")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 240, height: 120)
                        .background(isTypingDone ? Color.blue : Color.gray)
                        .cornerRadius(32)
                        .scaleEffect(CGSize(width: 0.8, height: 0.8))
                        .position(CGPoint(x: 1085, y: 200))
                }
                .disabled(!isTypingDone)  // Only enable after typing is done
            }
        }
        .onAppear {
            startTypingEffect()
        }
        .onTapGesture {
            if !isTypingDone {
                timer?.invalidate()
                displayedText = storyChunks[currentChunkIndex]
                isTypingDone = true
                audioPlayer?.stop()
            }
        }
    }

    // Start the typing effect
    func startTypingEffect() {
        displayedText = ""
        charIndex = 0
        isTypingDone = false
        timer?.invalidate()

        playTypingSound()

        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {
            _ in
            if charIndex < storyChunks[currentChunkIndex].count {
                let index = storyChunks[currentChunkIndex].index(
                    storyChunks[currentChunkIndex].startIndex,
                    offsetBy: charIndex)
                displayedText.append(storyChunks[currentChunkIndex][index])
                charIndex += 1
            } else {
                timer?.invalidate()
                isTypingDone = true
                audioPlayer?.stop()
            }
        }
    }

    // Function to play typing sound
    func playTypingSound() {
        guard
            let url = Bundle.main.url(
                forResource: "text-scroll-8bit", withExtension: "mp3")
        else {
            print("Audio file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 1
            audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }

    // Move to the next chunk of text
    func nextChunk() {
        if currentChunkIndex < storyChunks.count - 1 {
            currentChunkIndex += 1
            startTypingEffect()
        } else {
            print("Move to next scene")  // You can trigger scene transition here
        }
    }
}

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect, byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct Scene1_Previews: PreviewProvider {
    static var previews: some View {
        Scene1()
    }
}
