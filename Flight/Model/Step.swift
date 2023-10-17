//
//  Step.swift
//  Flight
//
//  Created by Ivan on 17/10/23.
//

import CoreLocation
import MapKit
import SwiftUI

struct Step: Identifiable, Equatable {
    static func == (lhs: Step, rhs: Step) -> Bool {
        lhs.name == rhs.name
    }

    let name: String
    let coordinate: CLLocationCoordinate2D
    var id: String { name }

    init(name: String, coordinate: Coordinate) {
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.long)
    }
}
