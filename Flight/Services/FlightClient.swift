//
//  FlightService.swift
//  Flight
//
//  Created by Ivan on 16/10/23.
//

import Foundation

struct FlightClient {
    var cheapestRoute: (
        _ from: String,
        _ to: String,
        _ connections: [Connection]
    ) -> [Connection]

    static let mock = Self { _, _, _ in
        [.init(
            from: "Palma",
            to: "Barcelona",
            price: 10,
            coordinates: .init(from: .pmi, to: .bcn)
        )]
    }

    static let live = Self { from, to, connections in
        var cheapestRoute: [Connection] = []

        findRoutes(
            from: from,
            to: to,
            currentRoute: [],
            currentPrice: 0.0,
            cheapestRoute: &cheapestRoute,
            connections: connections
        )

        return cheapestRoute
    }

    private static func findRoutes(
        from: String,
        to: String,
        currentRoute: [Connection],
        currentPrice: Double,
        cheapestRoute: inout [Connection],
        connections: [Connection]
    ) {
        if from == to {
            if (currentRoute.price < cheapestRoute.price) || cheapestRoute.isEmpty {
                cheapestRoute = currentRoute
            }
            return
        }

        for connection in connections {
            if connection.from == from && !currentRoute.contains (where: { $0.from == connection.to }) {
                var newRoute = currentRoute
                newRoute.append(connection)
                findRoutes(
                    from: connection.to,
                    to: to,
                    currentRoute: newRoute,
                    currentPrice: currentPrice + connection.price,
                    cheapestRoute: &cheapestRoute,
                    connections: connections
                )
            }
        }
    }
}
