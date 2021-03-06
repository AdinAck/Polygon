//
//  ContentView.swift
//  Polygon
//
//  Created by Adin Ackerman on 12/16/21.
//

import SwiftUI

struct ContentView: View {
    @State private var center = CGPoint(
        x: UIScreen.main.bounds.width/2,
        y: UIScreen.main.bounds.height/5)
    @State private var edges = 3
    @State private var radius = 100.0
    
    @State private var textField: String = "100"
    @State private var orientation: Orientation = .vertexOnTop
    @State private var showApothem: Bool = true
    
    let maxEdges: Int = 20
    let maxRadius: CGFloat = UIScreen.main.bounds.width*0.4
    
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
        VStack {
            PolygonView(
                edges: $edges,
                radius: $radius,
                orientation: $orientation,
                showApothem: $showApothem,
                maxEdges: maxEdges,
                maxRadius: maxRadius,
                anim: anim
            )
            PanelView(
                edges: $edges,
                radius: $radius,
                textField: textField,
                showApothem: $showApothem,
                anim: anim
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
