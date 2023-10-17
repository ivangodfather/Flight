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
        return reduce([]) { partialResult, connection in
            var newSteps = [connection.fromStep]
            if connection == last {
                newSteps.append(connection.toStep)
            }
            return partialResult + newSteps
        }
    }
}

