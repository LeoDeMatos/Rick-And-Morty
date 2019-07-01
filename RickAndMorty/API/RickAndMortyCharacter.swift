//
//  RickAndMortyCharacter.swift
//  RickAndMorty
//
//  Created by Leonardo de Matos on 29/06/19.
//  Copyright © 2019 Leonardo de Matos. All rights reserved.
//

struct RickAndMortyCharacter: Codable {
    let id: Int
    let name: String
    let species: String
    let image: String
    let origin: Origin
    let episode: [String]?
}

struct Origin: Codable {
    let name: String
}
