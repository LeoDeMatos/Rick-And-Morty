//
//  RickAndMortyWorker.swift
//  CombineSample
//
//  Created by Leonardo de Matos on 29/06/19.
//  Copyright © 2019 Leonardo de Matos. All rights reserved.
//

import Foundation
import Combine

struct Some: Codable {
    let string: String
}

struct HTTPError: Error {}
struct StatusCodeError: Error {}

class RickAndMortyWorker {
    
    var characters: [RickAndMortyCharacter] = []
    
    lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func fetchAllCharacters() {
        let endpoint = RickAndMortyAPI.allCharacters
        let url = URL(string: endpoint.url)!
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        let session = URLSession.shared.dataTaskPublisher(for: request)
        
        _ = session
            .tryMap(responseMapper)
            .decode(type: RickAndMortyResponseWrapper<[RickAndMortyCharacter]>.self, decoder: jsonDecoder)
            .mapError(errorMapper)
            .map { result in result.results }
            .sink { [weak self] characters in
                self?.characters = characters
        }
    }
    
    func fetchSingleCharacter(_ character: RickAndMortyCharacter) {
        let endpoint = RickAndMortyAPI.singleCharacter(id: character.id)
        
        guard let url = URL(string: endpoint.url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        let session = URLSession.shared.dataTaskPublisher(for: request)
        
        _ = session
            .tryMap(responseMapper)
            .decode(type: RickAndMortyResponseWrapper<RickAndMortyCharacter>.self, decoder: jsonDecoder)
            .mapError(errorMapper)
            .sink { someValue in
                print(someValue)
        }
    }
    
    func fetchEpisode(_ episodeId: Int) {
        let endpoint = RickAndMortyAPI.episode(id: episodeId)
        
        guard let url = URL(string: endpoint.url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        let session = URLSession.shared.dataTaskPublisher(for: request)
        
        _ = session
            .tryMap(responseMapper)
            .decode(type: RickAndMortyResponseWrapper<Episode>.self, decoder: jsonDecoder)
            .mapError(errorMapper)
            .sink { someValue in
                print(someValue)
        }
    }
    
    private func responseMapper(data: Data, response: URLResponse) throws -> Data {
        guard let response = response as? HTTPURLResponse else { throw HTTPError() }
        guard response.statusCode == 200 else { throw StatusCodeError() }
        return data
    }
    
    private func errorMapper(error: Error) -> Error {
        print(error.localizedDescription)
        return error
    }
}
