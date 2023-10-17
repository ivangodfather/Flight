//
//  FlightView.swift
//  Flight
//
//  Created by Ivan on 16/10/23.
//

import SwiftUI

struct FlightView: View {
    @State private var viewModel = FlightViewModel()

    var body: some View {
        if viewModel.isLoading {
            ProgressView()
                .onAppear {
                    viewModel.onAppear()
                }
        } else {
            Form {
                flightSelections
                Button(action: viewModel.search) {
                    Text("Search")
                }
                if !viewModel.route.isEmpty {
                    RouteView(route: viewModel.route)
                }
                clearForm
            }
            .navigationTitle("Cheapest Flight")
        }
    }

    @ViewBuilder
    private var flightSelections: some View {
        FlightSelection(
            title: "Select your departure",
            placeholder: "From",
            systemImage: "airplane.departure",
            text: $viewModel.from,
            completions: viewModel.fromCompletions,
            completionTapped: viewModel.fromCompletionTapped
        )
        FlightSelection(
            title: "Select your arrival",
            placeholder: "To",
            systemImage: "airplane.arrival",
            text: $viewModel.to,
            completions: viewModel.toCompletions,
            completionTapped: viewModel.toCompletionTapped
        )
    }

    @ViewBuilder
    private var clearForm: some View {
        Section {
            Button(role: .destructive) {
                viewModel.clearForm()
            } label: {
                Text("Clear route")
            }
        } footer: {
            Text("By tapping your route will be lost")
        }
    }
}

#Preview {
    FlightView()
}
