//
//  FlightService.swift
//  Flight
//
//  Created by Ivan on 16/10/23.
//

import Foundation

protocol FlightClientProtocol {
    func findCheapestRoute(
        from: String,
        to: String,
        using connections: [Connection]
    ) -> [Connection]
}

struct FlightClient: FlightClientProtocol {
    func findCheapestRoute(
        from: String,
        to: String,
        using connections: [Connection]
    ) -> [Connection] {
        var cheapestRoute: [Connection] = []
        var cheapestPrice: Double = Double.infinity

        findRoutes(
            from: from,
            to: to,
            currentRoute: [],
            currentPrice: 0.0,
            cheapestRoute: &cheapestRoute,
            cheapestPrice: &cheapestPrice,
            connections: connections
        )

        return cheapestRoute
    }

    private func findRoutes(
        from: String,
        to: String,
        currentRoute: [Connection],
        currentPrice: Double,
        cheapestRoute: inout [Connection],
        cheapestPrice: inout Double,
        connections: [Connection]
    ) {
        if from == to {
            if currentPrice < cheapestPrice {
                cheapestRoute = currentRoute
                cheapestPrice = currentPrice
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
                    cheapestPrice: &cheapestPrice,
                    connections: connections
                )
            }
        }
    }
}
