//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import Foundation
import Core

public struct PokemonsTransformer: Mapper {
    public typealias Response = [PokemonItemResponse]
    
    public typealias Entity = [PokemonEntity]
    
    public typealias Domain = [PokemonDomainModel]
    
    private let pokemonTransformer = PokemonTransformer()
    
    public init(){}
    
    public func transformResponseToEntity(response: [PokemonItemResponse]) -> [PokemonEntity] {
        return response.map {
            pokemonTransformer.transformResponseToEntity(response: $0)
        }
    }
    
    public func transformEntityToDomain(entity: [PokemonEntity]) -> [PokemonDomainModel] {
        return entity.map {
            pokemonTransformer.transformEntityToDomain(entity: $0)
        }
    }
    
    public func transformResponseToDomain(response: [PokemonItemResponse]) -> [PokemonDomainModel] {
        return response.map {
            pokemonTransformer.transformResponseToDomain(response: $0)
        }
    }
    
    public func transformDomainToEntity(domain: [PokemonDomainModel]) -> [PokemonEntity] {
        return domain.map {
            pokemonTransformer.transformDomainToEntity(domain: $0)
        }
    }
    
}

