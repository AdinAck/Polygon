//
//  ContentView.swift
//  Polygon
//
//  Created by Adin Ackerman on 12/16/21.
//

import SwiftUI

struct ContentView: View {
    private var center = CGPoint(
        x: UIScreen.main.bounds.width/2,
        y: UIScreen.main.bounds.height/5)
    @State private var edges = 3
    @State private var radius = 100.0
        
    let maxEdges: Int = 20
    let maxRadius: CGFloat = UIScreen.main.bounds.width*0.4
    
    private func getPoints() -> [CGPoint] {
        var result = [CGPoint]()
        for i in 0...edges {
            let a: Double = Double(i)*Double.pi*Double(2)/Double(edges)
            let x: CGFloat = center.x - radius * Foundation.sin(a)
            let y: CGFloat = center.y - radius * Foundation.cos(a)
            
            result.append(CGPoint(x: x, y: y))
        }
        
        for _ in 0..<maxEdges-edges {
            result.append(CGPoint(x: center.x, y: center.y-radius))
        }
        
        return result
    }
    
    var body: some View {
        VStack {
            ZStack {
                let points = getPoints()
                ForEach(0..<maxEdges) { edge in
                    Line(start: points[edge], end: points[edge+1])
                        .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round))
                }
                .animation(.spring(response: 1/2, dampingFraction: 1, blendDuration: 1), value: edges)
                .animation(.easeInOut(duration: 1), value: radius)
            }
            List {
                Stepper(
                    value: $edges,
                    in: 3...maxEdges,
                    step: 1
                ) {
                    Text("Edges: \(edges)")
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
