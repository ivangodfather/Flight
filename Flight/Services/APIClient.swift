//
//  APIClient.swift
//  Flight
//
//  Created by Ivan on 16/10/23.
//

import Combine
import Foundation

protocol APIClientProtocol {
    func connections() -> AnyPublisher<[Connection], APIError>
}

struct APIClient: APIClientProtocol {
    func connections() -> AnyPublisher<[Connection], APIError> {
        let response: AnyPublisher<ConnectionResponse, APIError> = FlightEndpoint.connections.get()
        return response.map(\.connections).eraseToAnyPublisher()
    }
}

enum FlightEndpoint: Endpoint {
    case connections

    var path: String {
        switch self {
        case .connections:
            return "TuiMobilityHub/ios-code-challenge/master/connections.json"
        }

    }

    var method: HTTPMethod {
        switch self {
        case .connections:
            return .get
        }
    }

    var requestBody: Data? { nil }

    var serverURL: URL {
        switch self {
        case .connections:
            return URL(string: "https://raw.githubusercontent.com/")!
        }
    }

    var headers: [String : String] { [:] }

    var queryParameters: [String : String]? { [:] }
}

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var requestBody: Data? { get }
    var serverURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String]? { get }
}

enum HTTPMethod: String {
    case delete
    case get
    case patch
    case post
    case put
}

enum APIError: Error {
    case badServerResponse
    case invalidJSON
}

extension Endpoint {
    func get<T: Decodable>(
    ) -> AnyPublisher<T, APIError> {
        var urlComponents = URLComponents(url: serverURL.appendingPathComponent(path).absoluteURL, resolvingAgainstBaseURL: true) ?? URLComponents()
        urlComponents.queryItems = queryParameters?.map { URLQueryItem(name: $0.key, value: $0.value) }

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue.uppercased()
        request.httpBody = requestBody

        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }


        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    200...299 ~= httpResponse.statusCode
                else {
                    throw APIError.badServerResponse
                }
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw APIError.invalidJSON
                }

            }
            .mapError {
                return $0 as! APIError
            }
            .eraseToAnyPublisher()
    }
}
