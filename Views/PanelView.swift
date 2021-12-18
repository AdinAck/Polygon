//
//  PanelView.swift.swift
//  Polygon
//
//  Created by Adin Ackerman on 12/17/21.
//

import SwiftUI

struct PanelView: View {
    @Binding var edges: Int
    @Binding var radius: Double
    
    @State var textField: String
    @Binding var showApothem: Bool
    
    let maxEdges: Int = 20
    let maxRadius: CGFloat = UIScreen.main.bounds.width*0.4
    
    let anim: Animation
    
    var body: some View {
        List {
            Section(header: Text("Control")) {
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
