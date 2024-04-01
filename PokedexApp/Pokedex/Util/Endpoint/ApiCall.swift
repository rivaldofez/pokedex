//
//  ApiCall.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import Foundation

import Foundation

struct API {
    static let baseURL = "https://pokeapi.co/api/v2/"
}

protocol EndPoint {
    var url: String { get }
}

enum Endpoints {
    enum Gets: EndPoint {
        case pokemonPagination
        case pokemonSpecies(Int)
        case pokemon(Int)
        
        var url: String {
            switch self {
            case .pokemonPagination: return "\(API.baseURL)pokemon/?"
            case let .pokemonSpecies(id): return "\(API.baseURL)pokemon-species/\(id)"
            case let .pokemon(offset): return "\(API.baseURL)pokemon/?offset=\(offset)&limit=\(50)"
            }
        }
    }
}

