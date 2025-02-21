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
        let rect = CGRect(x: 100, y: 200, width: 200, height: 150)
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
                Color.brown.opacity(0.5).ignoresSafeArea()
                
                // Draw the border outline
                Path { path in
                    path.addRect(CGRect(x: 100, y: 200, width: 200, height: 150))
                }
                .stroke(Color.gray, lineWidth: 10)
                .opacity(0.5)
                
                // Highlight traced points
                ForEach(tracedPoints.sorted(), id: \.self) { index in
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                        .position(borderPoints[index])
                }
                
                if tracingComplete {
                    VStack {
                        Text("Well done!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Button("Next Scene") {
                            loadNextScene()
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
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
