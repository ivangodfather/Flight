//
//  FlightTests.swift
//  FlightTests
//
//  Created by Ivan on 16/10/23.
//

import XCTest
@testable import Flight

final class FlightTests: XCTestCase {

    let sut = FlightClient.live

    func testAtoDSelectsLongestRoute() throws {
        let connections: [Connection] = [
            .init(from: "A", to: "B", price: 1, coordinates: .mock),
            .init(from: "B", to: "C", price: 1, coordinates: .mock),
            .init(from: "C", to: "D", price: 1, coordinates: .mock),
            .init(from: "A", to: "D", price: 10, coordinates: .mock),
        ]

        let result = sut.cheapestRoute("A", "D", connections)

        XCTAssertEqual(result, Array(connections.prefix(3)))
    }

    func testAtoDSelectsShortestRoute() throws {
        let connections: [Connection] = [
            .init(from: "A", to: "B", price: 1, coordinates: .mock),
            .init(from: "B", to: "C", price: 1, coordinates: .mock),
            .init(from: "C", to: "D", price: 1, coordinates: .mock),
            .init(from: "A", to: "D", price: 1, coordinates: .mock),
        ]

        let result = sut.cheapestRoute("A", "D", connections)

        XCTAssertEqual(result, [connections.last!])
    }

    func testAtoDRouteIsNilWhenNoValidConnections() throws {
        let connections: [Connection] = [
            .init(from: "A", to: "B", price: 1, coordinates: .mock),
            .init(from: "B", to: "C", price: 1, coordinates: .mock),
            .init(from: "D", to: "E", price: 1, coordinates: .mock),
        ]

        let result = sut.cheapestRoute("A", "D", connections)

        XCTAssertTrue(result.isEmpty)
    }
}
