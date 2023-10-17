//
//  FlightViewModelTests.swift
//  FlightTests
//
//  Created by Ivan on 17/10/23.
//

@testable import Flight
import Combine
import XCTest

private extension Connection {
    static let pmiBcn = Connection(
        from: "Palma",
        to: "Barcelona",
        price: 10,
        coordinates: .init(from: .pmi, to: .bcn)
    )

    static let bcnOrly = Connection(
        from: "Barcelona",
        to: "Orly",
        price: 12,
        coordinates: .init(from: .bcn, to: .orly)
    )
}

final class FlightViewModelTests: XCTestCase {

    var mockApi: MockAPIClient {
        var mock = MockAPIClient()
        mock.valueToReturn = [.pmiBcn, .bcnOrly]
        return mock
    }

    var mockFlight: MockFlightClient {
        var mock = MockFlightClient()
        mock.valueToReturn = [.pmiBcn]
        return mock
    }

    func testOnAppearStopsLoading() throws {
        let sut = FlightViewModel(
            apiClient: mockApi,
            flightClient: mockFlight
        )

        XCTAssertTrue(sut.isLoading)

        sut.onAppear()

        XCTAssertFalse(sut.isLoading)
    }

    func testSearchValidRoute() throws {
        let sut = FlightViewModel(
            apiClient: mockApi,
            flightClient: mockFlight
        )

        sut.onAppear()
        sut.from = "Palma"
        sut.to = "Barcelona"
        sut.search()

        XCTAssertEqual(sut.route, [.pmiBcn])
    }

    func testShowFromCompletions() throws {
        let sut = FlightViewModel(
            apiClient: mockApi,
            flightClient: mockFlight
        )

        sut.onAppear()
        sut.from = "alm"

        XCTAssertEqual(sut.fromCompletions, ["Palma"])

        sut.from = "a"
        XCTAssertEqual(sut.fromCompletions, ["Palma", "Barcelona"])
    }

    func testShowToCompletions() throws {
        let sut = FlightViewModel(
            apiClient: mockApi,
            flightClient: mockFlight
        )

        sut.onAppear()
        sut.to = "alm"

        XCTAssertEqual(sut.toCompletions, []) // Only searches on "to"

        sut.to = "a"
        XCTAssertEqual(sut.toCompletions, ["Barcelona"])
    }
}
