//
//  NetworkService.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import Foundation
import UIKit

protocol NetworkProtocol {
    func executeRequest<T>(urlString: String) async throws -> T? where T: Decodable
    func fetchImage(urlString: String) async throws -> UIImage?
}

class NetworkService: NetworkProtocol {

    enum NetworkError: Error {
        case decodingError
        case networkError
        case imageError
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
    
    // MARK: TODO Change to downloadImage naming is more appropriate
    func fetchImage(urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            return image
        }
        catch {
            throw NetworkError.imageError
        }
    }
}
