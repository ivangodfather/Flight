//
//  FlightSelection.swift
//  Flight
//
//  Created by Ivan on 17/10/23.
//

import SwiftUI

struct FlightSelection: View {
    let title: String
    let placeholder: String
    let systemImage: String
    @Binding var text: String
    let completions: Set<String>
    let completionTapped: (String) -> Void

    var body: some View {
        Section {
            VStack(alignment: .leading) {
                TextField(placeholder, text: $text)
                if !completions.isEmpty {
                    ForEach(Array(completions), id: \.self) { completion in
                        HighlightedLabel(text: completion, highlighted: text)
                            .onTapGesture {
                                completionTapped(completion)
                            }
                    }
                }
            }
        } header: {
            Label(title, systemImage: systemImage)
        }
    }
}


#Preview {
    Form {
        FlightSelection(
            title: "Select your arrival",
            placeholder: "To",
            systemImage: "airplane.arrival",
            text: .constant("palm"),
            completions: ["Palma", "Las Palmas"],
            completionTapped: { _ in }
        )
    }
}
