//
//  File.swift
//  
//
//  Created by rivaldo on 02/04/24.
//

import Core
import Foundation

public struct CatchPokemonTransformer: Mapper {
    public typealias Response = Any
    
    public typealias Entity = CatchPokemonEntity
    
    public typealias Domain = CatchPokemonDomainModel
    
    public init() {
        
    }
    
    public func transformResponseToEntity(response: Any) -> CatchPokemonEntity {
        return CatchPokemonEntity()
    }
    
    public func transformEntityToDomain(entity: CatchPokemonEntity) -> CatchPokemonDomainModel {
        return CatchPokemonDomainModel(
            catchId: entity.catchId,
            id: entity.id,
            name: entity.name,
            nickname: entity.nickname,
            image: entity.image,
            type: (entity.type).components(separatedBy: ","),
            catchDate: entity.catchDate
        )
    }
    
    public func transformResponseToDomain(response: Any) -> CatchPokemonDomainModel {
        return CatchPokemonDomainModel(catchId: "", id: 0, name: "", nickname: "", image: "", type: [], catchDate: Date())
    }
    
    public func transformDomainToEntity(domain: CatchPokemonDomainModel) -> CatchPokemonEntity {
        let cpEntity = CatchPokemonEntity()
        cpEntity.catchId = domain.catchId
        cpEntity.id = domain.id
        cpEntity.name = domain.name
        cpEntity.nickname = domain.nickname
        cpEntity.image = domain.image
        cpEntity.type = (domain.type).joined(separator: ",")
        cpEntity.catchDate = domain.catchDate
        
        return cpEntity
    }
}
