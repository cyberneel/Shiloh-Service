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
        let rect = CGRect(x: 0, y: 0, width: 400, height: 150)
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
        GeometryReader { geometry in
            let xOffset: CGFloat = geometry.size.width / 2 - 215  // Center horizontally
            let yOffset: CGFloat = geometry.size.height / 2 - 42  // Center vertically

            if !sceneDone {
                ZStack {
                    Image("pixel-garden-color-soil")
                        .offset(x: 0, y: -25)
                        .scaleEffect(CGSize(width: 1.4, height: 1.4))

                    // Draw the border outline
                    Path { path in
                        path.addRect(
                            CGRect(x: 0, y: 0, width: 400, height: 150))
                    }
                    .stroke(Color.red, lineWidth: 10)
                    .opacity(0.5)
                    .offset(x: xOffset, y: yOffset)

                    // Highlight traced points
                    ForEach(tracedPoints.sorted(), id: \.self) { index in
                        Circle()
                            .fill(Color(red: 0.251, green: 0.176, blue: 0.153))
                            .frame(width: 12, height: 12)
                            .position(
                                x: borderPoints[index].x,
                                y: borderPoints[index].y
                            ).offset(x: xOffset, y: yOffset)
                    }

                    if tracingComplete {
                        VStack {
                            Text("Well done!")
                                .font(
                                    .system(
                                        size: 64, weight: .bold,
                                        design: .rounded)
                                )
                                .foregroundColor(.white)
                                .offset(x: -18 ,y: 95)
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
                            }
                            .offset(x: 450, y: 200)
                        }
                    } else {
                        VStack {
                            Text("Trace the RED lines to till")
                                .font(
                                    .system(
                                        size: 32, weight: .bold,
                                        design: .rounded)
                                )
                                .foregroundColor(.white)
                                .padding()
                                .multilineTextAlignment(.leading)
                                .frame(width: 500, height: 180)
                                .background(Color.black.opacity(0.6))
                                .cornerRadius(32)
                                .transition(.opacity)
                                .padding()
                                .offset(y: 275)
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if !tracingComplete {
                                checkTracing(
                                    at: value.location, with: xOffset, yOffset)
                            }
                        }
                )
            } else {
                Text("Scene 5")
            }
        }
    }

    func checkTracing(
        at location: CGPoint, with xOffset: CGFloat, _ yOffset: CGFloat
    ) {
        for (index, point) in borderPoints.enumerated()
        where !tracedPoints.contains(index) {
            let adjustedPoint = CGPoint(
                x: point.x + xOffset, y: point.y + yOffset)
            let distance = hypot(
                location.x - adjustedPoint.x, location.y - adjustedPoint.y)
            if distance < 60 {
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
