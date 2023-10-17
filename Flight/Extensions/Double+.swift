//
//  Double+.swift
//  Flight
//
//  Created by Ivan on 17/10/23.
//

import Foundation

extension Double {
    var inCurrency: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = .current

        return numberFormatter.string(from: .init(value: self)) ?? ""
    }
}
