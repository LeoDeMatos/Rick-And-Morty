//
//  RickAndMortyAPI.swift
//  CombineSample
//
//  Created by Leonardo de Matos on 29/06/19.
//  Copyright © 2019 Leonardo de Matos. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
}

struct RickAndMortyAPIConfiguration {
    static var baseUrl: String = "https://rickandmortyapi.com/api/"
}

struct RickAndMortyResponseWrapper<T: Codable>: Codable{
    let results: T
}

enum RickAndMortyAPI {
    case allCharacters
    case singleCharacter(id: Int)
    case episode(id: Int)
    
    var url: String {
        let base = RickAndMortyAPIConfiguration.baseUrl
        switch self {
        case .allCharacters:
            return base + "character/"
            
        case .singleCharacter(let id):
            return base + "character/\(id)"
            
        case .episode(let id):
            return base + "episode/\(id)"
        }
    }
    
    var params: URLQueryItem? {
        return nil
    }
    
    var method: HttpMethod {
        return .get
    }
}
