//
//  MockAPIClient.swift
//  FlightTests
//
//  Created by Ivan on 17/10/23.
//

@testable import Flight
import Combine

struct MockAPIClient: APIClientProtocol {
    var valueToReturn = [Connection]()
    func connections() -> AnyPublisher<[Connection], APIError> {
        Just(valueToReturn)
        .setFailureType(to: APIError.self)
        .eraseToAnyPublisher()
    }
}
