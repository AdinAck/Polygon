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
    
    @State private var textField: String = "100"
    @State private var orientation: Orientation = .vertexOnTop
    @State private var showApothem: Bool = true
    
    private let anim = Animation.spring(response: 1/2, dampingFraction: 1, blendDuration: 0)
    
    let maxEdges: Int = 20
    let maxRadius: CGFloat = UIScreen.main.bounds.width*0.4
    
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
            ZStack {
                let points = getPoints()
                let midpoint = CGPoint(x: (points[0].x + points[1].x)/2.0, y: (points[0].y + points[1].y)/2.0)

                Line(start: CGPoint(x: center.x, y: center.y), end: midpoint)
                    .stroke(.gray, style: StrokeStyle(lineWidth: showApothem ? 4.0 : 0.0, lineCap: .round, dash: [10]))
                ForEach(0..<maxEdges) { edge in
                    Line(start: points[edge], end: points[edge+1])
                        .stroke(style: StrokeStyle(lineWidth: edge < edges ? 4.0 : 0.0, lineCap: .round))
                }
            }
            .animation(anim, value: edges)
            .animation(.spring(response: 1/2, dampingFraction: 1, blendDuration: 0), value: radius)
            List {
                Section(header: Text("Control")) {
                    Stepper(
                        value: $edges,
                        in: 3...maxEdges,
                        step: 1
                    ) {
                        Text("Edges: \(edges)")
                    }
                    .onChange(of: edges) { _ in
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()

                        withAnimation(anim) {
                            orientation = orientation == .vertexOnTop ? .edgeOnTop : .vertexOnTop
                        }
                    }
                    .padding()
                    VStack {
                        HStack {
                            Text("Radius")
                            Spacer()
                            TextField("", text: $textField)
                                .frame(width: 44.0)
                                .submitLabel(.go)
                                .onSubmit {
                                    radius = max(1, min(maxRadius, Double(textField) ?? 100))
                                }
                                .foregroundColor(Double(textField) != nil && (1...maxRadius).contains(Double(textField)!) ? .blue : .red)
                        }
                        .padding()
                        .textFieldStyle(.roundedBorder)
                        Slider(
                            value: $radius,
                            in: 1...maxRadius
                        ) {
                        } minimumValueLabel: {
                            Text("1")
                        } maximumValueLabel: {
                            Text("\(Int(maxRadius))")
                        }
                        .padding()
                        .onChange(of: radius) { _ in
                            textField = String(Int(radius))
                        }
                    }
                }
                Section(header: Text("Info")) {
                    let edgeLength = 2.0*radius*sin(Double.pi/Double(edges))
                    let apothem = radius*cos(Double.pi/Double(edges))
                    let area = (edgeLength*edgeLength*Double(edges))/(4.0*tan(Double.pi/Double(edges)))
                    HStack {
                        Text("Edge length")
                        Spacer()
                        Text("\(Int(edgeLength)) u")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Perimeter")
                        Spacer()
                        Text("\(Int(edgeLength*Double(edges))) u")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Perimeter (% of circle)")
                        Spacer()
                        Text("\(Int(100.0*edgeLength*Double(edges)/(2.0*Double.pi*radius)))%")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Area")
                        Spacer()
                        Text("\(Int(area)) u\u{B2}")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Area (% of circle)")
                        Spacer()
                        Text("\(Int(100.0*area/(Double.pi*radius*radius)))%")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Apothem")
                        Spacer()
                        Text("\(Int(apothem)) u")
                            .foregroundColor(.gray)
                    }
                }
                Section(header: Text("Settings")) {
                    Toggle("Show apothem line", isOn: $showApothem.animation(anim))
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
