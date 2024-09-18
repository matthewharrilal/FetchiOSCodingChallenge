//
//  NetworkService.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import Foundation

protocol NetworkProtocol {
    func executeRequest<T>(urlString: String) async throws -> T? where T: Decodable
}

class NetworkService: NetworkProtocol {

    enum NetworkError: Error {
        case decodingError
        case networkError
    }
    
    func executeRequest<T>(urlString: String) async throws -> T? where T: Decodable {
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let results = try JSONDecoder().decode(T.self, from: data)
            return results
        }
        catch _ as DecodingError{
            throw NetworkError.decodingError
        }
        catch {
            throw NetworkError.networkError
        }
    }
}
