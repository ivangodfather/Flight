//
//  HighlightedLabel.swift
//  Flight
//
//  Created by Ivan on 17/10/23.
//

import SwiftUI

struct HighlightedLabel: View {
    let text: String
    let highlighted: String

    var body: some View {
        Text(attributedString)
    }

    private var attributedString: AttributedString {
        var attributedString = AttributedString(text)

        if let range = attributedString.range(of: highlighted, options: .caseInsensitive) {
            attributedString[range].font = .system(size: 17, weight: .bold)
        }

        return attributedString
    }
}

#Preview {
    HighlightedLabel(text: "New York", highlighted: "york")
}
