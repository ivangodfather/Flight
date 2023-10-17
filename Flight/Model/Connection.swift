//
//  Connection.swift
//  Connection
//
//  Created by Ivan on 16/10/23.
//

import CoreLocation
import Foundation

struct ConnectionResponse: Decodable {
    let connections: [Connection]
}

struct Connection: Decodable, Equatable, Identifiable {
    let from: String
    let to: String
    let price: Double

    let coordinates: Coordinates

    var id: String {
        from + to + price.description
    }
}

struct Coordinates: Decodable, Equatable {
    let from: Coordinate
    let to: Coordinate
}

extension Coordinates {
    static let mock = Coordinates(from: .pmi, to: .bcn)
}

struct  Coordinate: Decodable, Equatable {
    let lat: Double
    let long: Double
}

extension Coordinate {
    static let pmi = Coordinate(lat: 39.5699526, long: 2.6807551)
    static let bcn = Coordinate(lat: 41.2980327, long: 2.0773277)
    static let orly = Coordinate(lat: 48.7272255, long: 2.359745)
}
