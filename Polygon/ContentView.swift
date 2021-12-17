//
//  ContentView.swift
//  Polygon
//
//  Created by Adin Ackerman on 12/16/21.
//

import SwiftUI

enum Orientation {
    case vertexOnTop
    case edgeOnTop
}

struct ContentView: View {
    private var center = CGPoint(
        x: UIScreen.main.bounds.width/2,
        y: UIScreen.main.bounds.height/5)
    @State private var edges = 3
    @State private var radius = 100.0
    
    @State private var orientation: Orientation = .vertexOnTop
    
    private let anim = Animation.spring(response: 1/2, dampingFraction: 0.75, blendDuration: 0)
    
    let maxEdges: Int = 20
    let maxRadius: CGFloat = UIScreen.main.bounds.width*0.4
    
    private func getPoints() -> [CGPoint] {
        var result = [CGPoint]()
        for i in 0...edges {
            var a: Double = Double(i)*Double.pi*2.0/Double(edges)
            if orientation == .edgeOnTop {
                a += Double.pi/Double(edges)
            }
                
            let x: CGFloat = center.x - radius * Foundation.sin(a)
            let y: CGFloat = center.y - radius * Foundation.cos(a)
            
            result.append(CGPoint(x: x, y: y))
        }
        
        for _ in 0..<maxEdges-edges {
            result.append(CGPoint(x: result[0].x, y: result[0].y))
        }
        
        return result
    }
    
    var body: some View {
        VStack {
            ZStack {
                let points = getPoints()
                ForEach(0..<maxEdges) { edge in
                    Line(start: points[edge], end: points[edge+1])
                        .stroke(style: StrokeStyle(lineWidth: edge < edges ? 4.0 : 0.0, lineCap: .round))
                }
                .animation(anim, value: edges)
                .animation(.spring(response: 1/2, dampingFraction: 1, blendDuration: 0), value: radius)
            }
            List {
                Stepper(
                    value: $edges,
                    in: 3...maxEdges,
                    step: 1
                ) {
                    Text("Edges: \(edges)")
                }
                .onChange(of: edges) { _ in
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    
                    withAnimation(anim) {
                        orientation = orientation == .vertexOnTop ? .edgeOnTop : .vertexOnTop
                    }
                }
                .padding()
                VStack {
                    HStack {
                        Text("Radius")
                        Spacer()
                        Text("\(Int(radius))")
                            .foregroundColor(.blue)
                    }
                    .padding()
                    Slider(
                        value: $radius,
                        in: 0...maxRadius
                    ) {
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("\(Int(maxRadius))")
                    }
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
