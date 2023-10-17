//
//  Connection+.swift
//  Flight
//
//  Created by Ivan on 17/10/23.
//

import Foundation

extension Array where Element == Connection {
    var price: Double {
        self.map(\.price).reduce(0, +)
    }

    var steps: [Step] {
        var steps = [Step]()
        for connection in self {
            steps.append(.init(name: connection.from, coordinate: connection.coordinates.from))
            if connection == last {
                steps.append(.init(name: connection.to, coordinate: connection.coordinates.to))
            }
        }
        return steps
    }
}
