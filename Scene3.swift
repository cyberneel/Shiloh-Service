//
//  Scene3.swift
//  Shiloh Service
//
//  Created by Neelesh Chevuri on 2/19/25.
//

import AVFoundation
import SwiftUI

struct Scene3: View {
    let storyChunks = [
        "Good morning!",
        "My name is Wade.",
        "Thank you for coming out to help!",
        "We are about to plant some potatoes.",
        "But there are waaay too many weeds in the field.",
        "Let’s see if we can get rid of them."
    ]

    @State private var currentChunkIndex = 0
    @State private var displayedText = ""
    @State private var charIndex = 0
    @State private var timer: Timer?
    @State private var isTypingDone = false

    @State private var sceneDone = false

    var body: some View {
        if sceneDone == false {
            ZStack {
                Image("pixel-garden-color-weed")
                    .offset(x: 0, y: -25)
                    .scaleEffect(CGSize(width: 1.4, height: 1.4))
                
                Image("pixel-gardener")
                    .scaleEffect(CGSize(width: -1, height: 1))
                    .rotationEffect(Angle(degrees: 7))
                    .offset(x: -450, y: 300)
                    .zIndex(10)

                VStack {
                    Text(displayedText)
                        .font(
                            .system(size: 24, weight: .bold, design: .rounded)
                        )
                        .foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.leading)
                        .frame(width: 500, height: 200)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(32)
                        .transition(.opacity)
                        .padding()
                        .offset(x: -0, y: 325)

                    Button(action: {
                        if !isTypingDone {
                            timer?.invalidate()
                            displayedText = storyChunks[currentChunkIndex]
                            isTypingDone = true
                            audioPlayer?.stop()
                        } else {
                            nextChunk()
                        }
                    }) {
                        Text("Next")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 240, height: 120)
                            .background(isTypingDone ? Color.blue : Color.gray)
                            .cornerRadius(32)
                    }.contentShape(Rectangle())
                        .frame(width: 240 * 0.8, height: 120 * 0.8)  // Ensures tappable area matches visual size
                        .offset(x: 450, y: 200)  // Adjust button position instead of `position()`

                }
            }
            .onAppear {
                startTypingEffect()
            }
        } else {
            WeedWhacker().transition(.blurReplace)
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
            withAnimation {
                sceneDone = true
            }
        }
    }
}

struct Scene3View_Previews: PreviewProvider {
    static var previews: some View {
        Scene3()
    }
}
