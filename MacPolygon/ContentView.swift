//
//  ContentView.swift
//  MacPolygon
//
//  Created by Adin Ackerman on 12/17/21.
//

import SwiftUI

struct ContentView: View {
    @State private var center = CGPoint(
        x: 150,
        y: 200)
    @State private var edges = 3
    @State private var radius = 100.0
    
    @State private var orientation: Orientation = .vertexOnTop
    @State private var showApothem: Bool = true
    
    let maxEdges: Int = 20
    @State var maxRadius: CGFloat = 1000
    
    private let anim = Animation.spring(response: 1/2, dampingFraction: 1, blendDuration: 0)
    
    private func getPoints() -> [CGPoint] {
        var result = [CGPoint]()
        for i in 0...edges {
            var a: Double = Double(i)*Double.pi*2.0/Double(edges)
            if orientation == .edgeOnTop {
                a += Double.pi/Double(edges)
            }
                
            let x: CGFloat = center.x - radius * sin(a)
            let y: CGFloat = center.y - radius * cos(a)
            
            result.append(CGPoint(x: x, y: y))
        }
        
        for _ in 0..<maxEdges-edges {
            result.append(CGPoint(x: result[0].x, y: result[0].y))
        }
        
        return result
    }
    
    var body: some View {
        HStack {
            NavigationView {
                PanelView(
                    edges: $edges,
                    radius: $radius,
                    showApothem: $showApothem,
                    maxEdges: maxEdges,
                    maxRadius: maxRadius,
                    anim: anim
                )
                PolygonView(
                    edges: $edges,
                    radius: $radius,
                    orientation: $orientation,
                    showApothem: $showApothem,
                    maxEdges: maxEdges,
                    maxRadius: maxRadius,
                    anim: anim
                )
                    .frame(minWidth: 300)
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
