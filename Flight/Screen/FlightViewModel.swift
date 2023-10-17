//
//  FlightViewModel.swift
//  Flight
//
//  Created by Ivan on 16/10/23.
//

import Combine
import Foundation
import Observation

final class FlightViewModel: ObservableObject {
    @Published var from = ""
    @Published var fromCompletions = Set<String>()

    @Published var to = ""
    @Published var toCompletions = Set<String>()

    @Published var isLoading = true
    @Published var route = [Connection]()


    private let apiClient: APIClientProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published private var connections = [Connection]()
    private let flightClient: FlightClientProtocol
    private let fromPublisher = PassthroughSubject<String, Never>()
    private let toPublisher = PassthroughSubject<String, Never>()


    init(
        apiClient: APIClientProtocol = APIClient(),
        flightClient: FlightClientProtocol = FlightClient()
    ) {
        self.apiClient = apiClient
        self.flightClient = flightClient

        $from.combineLatest($connections)
        .map { from, connections in
            connections
                .filter { $0.from.localizedStandardContains(from) }
                .map(\.from)
        }
        .map(Set.init)
        .sink { [weak self] completions in
            guard let self = self else {
                return
            }
            self.fromCompletions = completions.contains(self.from) ? [] : completions

        }
        .store(in: &cancellables)

        $to.combineLatest($connections)
        .map { to, connections in
            connections
                .filter { $0.to.localizedStandardContains(to) }
                .map(\.to)
        }
        .map(Set.init)
        .sink { [weak self] completions in
            guard let self = self else {
                return
            }
            self.toCompletions = completions.contains(self.to) ? [] : completions
        }
        .store(in: &cancellables)
    }

    func onAppear() {
        apiClient.connections()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] connections in
                self?.connections = connections
            }
            .store(in: &cancellables)
    }

    func search() {
        route = flightClient.findCheapestRoute(
            from: from,
            to: to,
            using: connections
        )
    }

    func clearForm() {
        from = ""
        to = ""
        route = []
        fromCompletions = []
        toCompletions = []
    }

    func fromCompletionTapped(_ completion: String) {
        from = completion
        fromCompletions = []
    }

    func toCompletionTapped(_ completion: String) {
        to = completion
        toCompletions = []
    }
}
