//
//  MockFlightClient.swift
//  FlightTests
//
//  Created by Ivan on 17/10/23.
//

@testable import Flight
import Combine

struct MockFlightClient: FlightClientProtocol {
    var valueToReturn = [Connection]()
    func findCheapestRoute(from: String, to: String, using connections: [Connection]) -> [Connection] {
        valueToReturn
    }
}
