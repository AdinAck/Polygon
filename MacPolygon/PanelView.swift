//
//  PanelView.swift
//  MacPolygon
//
//  Created by Adin Ackerman on 12/17/21.
//

import SwiftUI

struct PanelView: View {
    @Binding var edges: Int
    @Binding var radius: Double
    var edgesProxy: Binding<Double>{
        Binding<Double>(get: {
            return Double(edges)
        }, set: {
            edges = Int($0)
        })
    }
    
    @State var radiusText: String = "100"
    @State var edgesText: String = "3"
    @Binding var showApothem: Bool
    
    let maxEdges: Int
    @State var maxRadius: CGFloat
    
    let anim: Animation
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    var body: some View {
        List {
            Section(header: Text("Control")) {
                VStack {
                    HStack {
                        Text("Edges")
                        Spacer()
                        TextField("", text: $edgesText)
                            .frame(width: 44.0)
                            .submitLabel(.go)
                            .onSubmit {
                                edges = max(3, min(maxEdges, Int(edgesText) ?? 3))
                            }
                            .foregroundColor(Double(edgesText) != nil && (3...maxEdges).contains(Int(edgesText)!) ? .blue : .red)
                    }
                    .textFieldStyle(.roundedBorder)
                    Slider(
                        value: edgesProxy,
                        in: 3...Double(maxEdges),
                        step: 1
                    ) {
                    } minimumValueLabel: {
                        Text("3")
                    } maximumValueLabel: {
                        Text("\(Int(maxEdges))")
                    }
                    .onChange(of: edges) { _ in
                        edgesText = String(Int(edges))
                    }
                }
                VStack {
                    HStack {
                        Text("Radius")
                        Spacer()
                        TextField("", text: $radiusText)
                            .frame(width: 44.0)
                            .submitLabel(.go)
                            .onSubmit {
                                radius = max(1, min(maxRadius, Double(radiusText) ?? 100))
                            }
                            .foregroundColor(Double(radiusText) != nil && (1...maxRadius).contains(Double(radiusText)!) ? .blue : .red)
                    }
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
                    .onChange(of: radius) { _ in
                        radiusText = String(Int(radius))
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
        .navigationTitle("Test")
        .frame(minWidth: 300)
        .listStyle(SidebarListStyle())
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.leading")
                })
            }
        }
    }
}
