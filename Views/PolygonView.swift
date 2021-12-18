//
//  PolygonView.swift
//  Polygon
//
//  Created by Adin Ackerman on 12/17/21.
//

import SwiftUI

struct PolygonView: View {
    @Binding var edges: Int
    @Binding var radius: Double
    
    @Binding var orientation: Orientation
    @Binding var showApothem: Bool
    
    let maxEdges: Int
    @State var maxRadius: CGFloat
    
    let anim: Animation
    
    private func getPoints(_ geometry: GeometryProxy) -> [CGPoint] {
        var result = [CGPoint]()
        for i in 0...edges {
            var a: Double = Double(i)*Double.pi*2.0/Double(edges)
            if orientation == .edgeOnTop {
                a += Double.pi/Double(edges)
            }
                
            let x: CGFloat = geometry.size.width/2 - radius * sin(a)
            let y: CGFloat = geometry.size.height/2 - radius * cos(a)
            
            result.append(CGPoint(x: x, y: y))
        }
        
        for _ in 0..<maxEdges-edges {
            result.append(CGPoint(x: result[0].x, y: result[0].y))
        }
        
        return result
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let points = getPoints(geometry)
                let midpoint = CGPoint(x: (points[0].x + points[1].x)/2.0, y: (points[0].y + points[1].y)/2.0)

                Line(start: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2), end: midpoint)
                    .stroke(.gray, style: StrokeStyle(lineWidth: showApothem ? 4.0 : 0.0, lineCap: .round, dash: [10]))
                ForEach(0..<maxEdges) { edge in
                    Line(start: points[edge], end: points[edge+1])
                        .stroke(style: StrokeStyle(lineWidth: edge < edges ? 4.0 : 0.0, lineCap: .round))
                }
            }
            .animation(anim, value: edges)
            .animation(.spring(response: 1/2, dampingFraction: 1, blendDuration: 0), value: radius)
            .onChange(of: edges) { _ in
                #if os(iOS)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                #endif
                withAnimation(anim) {
                    orientation = edges % 2 == 0 ? .edgeOnTop : .vertexOnTop
                }
            }
        }
    }
}
