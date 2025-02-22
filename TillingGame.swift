//
//  TillingGame.swift
//  Shiloh Service
//
//  Created by Neelesh Chevuri on 2/21/25.
//

import SwiftUI

struct TillingGameView: View {
    @State private var tracedPoints: Set<Int> = []
    @State private var tracingComplete = false
    
    @State private var sceneDone = false

    // Define the points along the rectangle border
    let borderPoints: [CGPoint] = {
        var points: [CGPoint] = []
        let rect = CGRect(x: 390, y: 350, width: 400, height: 150)
        let step: CGFloat = 10

        // Top edge
        for x in stride(from: rect.minX, through: rect.maxX, by: step) {
            points.append(CGPoint(x: x, y: rect.minY))
        }
        // Right edge
        for y in stride(from: rect.minY, through: rect.maxY, by: step) {
            points.append(CGPoint(x: rect.maxX, y: y))
        }
        // Bottom edge
        for x in stride(from: rect.maxX, through: rect.minX, by: -step) {
            points.append(CGPoint(x: x, y: rect.maxY))
        }
        // Left edge
        for y in stride(from: rect.maxY, through: rect.minY, by: -step) {
            points.append(CGPoint(x: rect.minX, y: y))
        }

        return points
    }()

    var body: some View {
        if !sceneDone {
            ZStack {
                Image("pixel-garden-color-soil")
                    .offset(x: 0, y: -25)
                    .scaleEffect(CGSize(width: 1.4, height: 1.4))
                
                // Draw the border outline
                Path { path in
                    path.addRect(CGRect(x: 390, y: 350, width: 400, height: 150))
                }
                .stroke(Color.red, lineWidth: 10)
                .opacity(0.5)
                
                // Highlight traced points
                ForEach(tracedPoints.sorted(), id: \.self) { index in
                    Circle()
                        .fill(Color(red: 0.251, green: 0.176, blue: 0.153))
                        .frame(width: 12, height: 12)
                        .position(borderPoints[index])
                }
                
                if tracingComplete {
                    VStack {
                        Text("Well done!")
                            .font(
                                .system(size: 64, weight: .bold, design: .rounded)
                            )
                            .foregroundColor(.white)
                            .offset(x: 0, y: 75)
                        Button(action: {
                            print("Next Scene")
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
                        Text("Trace the RED lines to till")
                            .font(
                                .system(size: 24, weight: .bold, design: .rounded)
                            )
                            .foregroundColor(.white)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .frame(width: 500, height: 150)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(32)
                            .transition(.opacity)
                            .padding()
                            .offset(x: -0, y: 300)
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !tracingComplete {
                            checkTracing(at: value.location)
                        }
                    }
            )
        } else {
            Text("Scene 5")
        }
    }

    func checkTracing(at location: CGPoint) {
        for (index, point) in borderPoints.enumerated() where !tracedPoints.contains(index) {
            let distance = hypot(location.x - point.x, location.y - point.y)
            if distance < 50 {
                tracedPoints.insert(index)
                if tracedPoints.count == borderPoints.count {
                    tracingComplete = true
                }
                break
            }
        }
    }

    func loadNextScene() {
        tracingComplete = false
        tracedPoints.removeAll()
        sceneDone = true
    }
}

struct TillingGameApp_Preview: PreviewProvider {
    static var previews: some View {
        TillingGameView()
    }
}
