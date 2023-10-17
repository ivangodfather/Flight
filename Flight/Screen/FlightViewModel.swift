//
//  FlightViewModel.swift
//  Flight
//
//  Created by Ivan on 16/10/23.
//

import Combine
import Observation

@Observable
final class FlightViewModel {
    var from = "" {
        didSet {
            fromPublisher.send(from)
        }
    }
    var fromCompletions = Set<String>()

    var to = "" {
        didSet {
            toPublisher.send(to)
        }
    }
    var toCompletions = Set<String>()

    var isLoading = true
    var route = [Connection]()


    private let apiClient: APIClientProtocol
    private var cancellables = Set<AnyCancellable>()
    private var connections = [Connection]()
    private let flightClient: FlightClientProtocol
    private let fromPublisher = PassthroughSubject<String, Never>()
    private let toPublisher = PassthroughSubject<String, Never>()


    init(
        apiClient: APIClientProtocol = APIClient(),
        flightClient: FlightClientProtocol = FlightClient()
    ) {
        self.apiClient = apiClient
        self.flightClient = flightClient

        fromPublisher
        .map { [weak self] from in
            self?.connections.filter { $0.from.localizedCaseInsensitiveContains(from) } ?? []
        }
        .map { connections in
            connections.map(\.from)
        }
        .sink { [weak self] fromCompletions in
            if fromCompletions.contains(self?.from ?? "") {
                self?.fromCompletions = []
            } else {
                self?.fromCompletions = Set(fromCompletions)
            }
        }
        .store(in: &cancellables)

        toPublisher
        .map { [weak self] to in
            self?.connections.filter { $0.to.localizedCaseInsensitiveContains(to) } ?? []
        }
        .map { connections in
            connections.map(\.to)
        }
        .sink { [weak self] toCompletions in
            if toCompletions.contains(self?.to ?? "") {
                self?.toCompletions = []
            } else {
                self?.toCompletions = Set(toCompletions)
            }
        }
        .store(in: &cancellables)
    }

    func onAppear() {
        apiClient.connections().sink { [weak self] _ in
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
