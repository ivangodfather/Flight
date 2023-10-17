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

    func testOnAppearStopsLoading() throws {
        let sut = FlightViewModel(
            apiClient: .init(connections: {
                Just([.pmiBcn, .bcnOrly])
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
            }),
            flightClient: .mock
        )

        XCTAssertTrue(sut.isLoading)

        sut.onAppear()

        let expectation = XCTestExpectation(description: "Wait connections to be loaded")

        let cancellable = sut.$isLoading.dropFirst().sink { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(sut.isLoading)
        cancellable.cancel()
    }

    func testSearchValidRoute() throws {
        let sut = FlightViewModel(
            apiClient: .init(connections: {
                Just([.pmiBcn])
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
            }),
            flightClient: .mock
        )

        sut.onAppear()
        sut.from = "Palma"
        sut.to = "Barcelona"
        sut.search()

        XCTAssertEqual(sut.route, [.pmiBcn])
    }

    func testShowFromCompletions() throws {
        let sut = FlightViewModel(
            apiClient: .init(connections: {
                Just([.pmiBcn, .bcnOrly])
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
            }),
            flightClient: .mock
        )

        sut.onAppear()

        let firstExpectation = XCTestExpectation()

        var cancellable = sut.$fromCompletions.sink { completions in
            if !completions.isEmpty {
                firstExpectation.fulfill()
            }
        }
        sut.from = "alm"

        wait(for: [firstExpectation], timeout: 1)
        XCTAssertEqual(sut.fromCompletions, ["Palma"])


        cancellable.cancel()

        let secondExpectation = XCTestExpectation()

        cancellable = sut.$fromCompletions.sink { completions in
            if !completions.isEmpty {
                secondExpectation.fulfill()
            }
        }
        sut.from = "a"

        wait(for: [secondExpectation], timeout: 1)
        XCTAssertEqual(sut.fromCompletions, ["Palma", "Barcelona"])
        cancellable.cancel()
    }

    func testShowToCompletions() throws {
        let sut = FlightViewModel(
            apiClient: .init(connections: {
                Just([.pmiBcn])
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
            }),
            flightClient: .mock
        )

        sut.onAppear()

        let expectation = XCTestExpectation()

        let cancellable = sut.$toCompletions.sink { completions in
            if !completions.isEmpty {
                expectation.fulfill()
            }
        }
        sut.to = "bar"

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(sut.toCompletions, ["Barcelona"])
        cancellable.cancel()
    }


    /*
     If the user has already typed their destination correctly, it should not be suggested again.
     */
    func testCompletionsAreEmptyIfDestinationIsValid() throws {
        let sut = FlightViewModel(
            apiClient: .init(connections: {
                Just([.pmiBcn])
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
            }),
            flightClient: .mock
        )

        sut.onAppear()

        let fromExpectation = XCTestExpectation()

        var cancellable = sut.$fromCompletions.dropFirst().sink { completions in
            fromExpectation.fulfill()
        }
        sut.from = "Palma"

        wait(for: [fromExpectation], timeout: 1)
        XCTAssertEqual(sut.fromCompletions, [])
        cancellable.cancel()


        let toExpectation = XCTestExpectation()

        cancellable = sut.$toCompletions.dropFirst().sink { completions in
            toExpectation.fulfill()
        }
        sut.to = "Barcelona"

        wait(for: [toExpectation], timeout: 1)
        XCTAssertEqual(sut.toCompletions, [])
        cancellable.cancel()
    }
}
