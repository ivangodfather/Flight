//
//  MapRouteView.swift
//  Flight
//
//  Created by Ivan on 17/10/23.
//

import MapKit
import SwiftUI

struct MapRouteView: View {
    let route: [Connection]

    var body: some View {
        Map {
            ForEach(route.steps) { step in
                if step == route.steps.first {
                    Annotation(step.name, coordinate: step.coordinate, anchor: .bottom) {
                        image(name: "airplane.departure")
                    }
                } else if step == route.steps.last {
                    Annotation(step.name, coordinate: step.coordinate, anchor: .bottom) {
                        image(name: "airplane.arrival")
                    }
                } else {
                    Marker(step.name, coordinate: step.coordinate)
                }
            }

            MapPolyline(coordinates: route.steps.map(\.coordinate))
                .stroke(.blue, lineWidth: 6)
        }
        .navigationTitle("Route")
    }

    @ViewBuilder
    private func image(name: String) -> some View {
        Image(systemName: name)
            .padding(4)
            .foregroundStyle(.indigo)
            .background(Color.white)
    }
}

#Preview {
    MapRouteView(route: [
        .init(
            from: "Palma",
            to: "Barcelona",
            price: 10,
            coordinates: .init(
                from: .pmi,
                to: .bcn
            )
        ),
        .init(
            from: "Barcelona",
            to: "Orly",
            price: 12,
            coordinates: .init(
                from: .bcn,
                to: .orly
            )
        )
    ])
}
