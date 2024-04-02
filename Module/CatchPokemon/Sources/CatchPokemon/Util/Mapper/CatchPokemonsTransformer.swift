//
//  File.swift
//  
//
//  Created by rivaldo on 02/04/24.
//

import Core


public struct CatchPokemonsTransformer: Mapper {
    public typealias Response = [Any]
    
    public typealias Entity = [CatchPokemonEntity]
    
    public typealias Domain = [CatchPokemonDomainModel]
    
    private let cpTransformer = CatchPokemonTransformer()
    
    public init() {}
    
    public func transformResponseToEntity(response: [Any]) -> [CatchPokemonEntity] {
        return []
    }
    
    public func transformEntityToDomain(entity: [CatchPokemonEntity]) -> [CatchPokemonDomainModel] {
        return entity.map {
            cpTransformer.transformEntityToDomain(entity: $0)
        }
    }
    
    public func transformResponseToDomain(response: [Any]) -> [CatchPokemonDomainModel] {
        return []
    }
    
    public func transformDomainToEntity(domain: [CatchPokemonDomainModel]) -> [CatchPokemonEntity] {
        return domain.map {
            cpTransformer.transformDomainToEntity(domain: $0)
        }
    }
}
