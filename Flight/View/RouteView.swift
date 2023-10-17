//
//  RouteView.swift
//  Flight
//
//  Created by Ivan on 17/10/23.
//

import SwiftUI

struct RouteView: View {
    let route: [Connection]
    var body: some View {
        Section {
            ForEach(route) { connection in
                LabeledContent(
                    "\(connection.from) \(Image(systemName: "arrow.turn.down.right")) \(connection.to)",
                    value: connection.price.inCurrency
                )
            }
        } header: {
            Label("Route", systemImage: "point.topleft.down.to.point.bottomright.filled.curvepath")
        }
        LabeledContent {
            Text(route.price.inCurrency)
        } label: {
            Label("Amount", systemImage: "eurosign")
        }

        NavigationLink {
            MapRouteView(route: route)
        } label: {
            Label("Show in map", systemImage: "map")
        }
    }
}

#Preview {
    Form {
        RouteView(route: [
            .init(from: "Palma", to: "Barcelona", price: 10, coordinates: .init(from: .pmi, to: .bcn)),
            .init(from: "Barcelona", to: "Orly", price: 20, coordinates: .init(from: .bcn, to: .orly))
        ])
    }
}
