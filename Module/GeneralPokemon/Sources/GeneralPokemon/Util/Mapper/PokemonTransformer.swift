//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import Core
import RealmSwift

public struct PokemonTransformer: Mapper {
    public typealias Response = PokemonItemResponse
    
    public typealias Entity = PokemonEntity
    
    public typealias Domain = PokemonDomainModel
    
    public init(){}
    
    public func transformResponseToEntity(response: PokemonItemResponse) -> PokemonEntity {
        
        let image = response.sprites.other.officialArtwork.frontDefault ??
        response.sprites.other.dreamWorld.frontDefault ??
        response.sprites.other.home.frontDefault ?? ""
        
        let pokemonEntity = PokemonEntity()
        let baseStat = List<BaseStatEntity>()
        baseStat.append(
            objectsIn:
                response.stats.map {
                    let baseStatEntity = BaseStatEntity()
                    baseStatEntity.name = $0.stat.name
                    baseStatEntity.effort = $0.effort
                    baseStatEntity.url = $0.stat.url
                    baseStatEntity.value = $0.baseStat
                    return baseStatEntity
                }
        )
        
        pokemonEntity.id = response.id
        pokemonEntity.name = response.name
        pokemonEntity.image = image
        pokemonEntity.height = Float(response.height) / 10.0
        pokemonEntity.weight = Float(response.weight) / 10.0
        pokemonEntity.baseExp = response.baseExperience
        pokemonEntity.baseStat = baseStat
        pokemonEntity.moves = response.moves.map { moveResponse in
            return moveResponse.move.name
        }.joined(separator: ",")
        
        pokemonEntity.type = response.types.map { typeResponse in
            return typeResponse.type.name
        }.joined(separator: ",")
        
        pokemonEntity.abilities = response.abilities.map { ability in
            ability.ability.name.capitalized
        }.joined(separator: ", ")
        
        pokemonEntity.isFavorite = false
        pokemonEntity.offset = response.offset
        
        return pokemonEntity
        
    }
    
    public func transformEntityToDomain(entity: PokemonEntity) -> PokemonDomainModel {
        return PokemonDomainModel(
            id: entity.id,
            name: entity.name,
            image: entity.image,
            height: entity.height,
            weight: entity.weight,
            baseExp: entity.baseExp,
            baseStat: entity.baseStat.map {
                return BaseStat(name: $0.name, effort: $0.effort, value: $0.value, url: $0.url)
            },
            moves: entity.moves.components(separatedBy: ","),
            type: entity.type.components(separatedBy: ","),
            abilities: entity.abilities,
            isFavorite: entity.isFavorite,
            offset: entity.offset
        )
    }
    
    public func transformResponseToDomain(response: PokemonItemResponse) -> PokemonDomainModel {
        
        let image = response.sprites.other.officialArtwork.frontDefault ??
        response.sprites.other.dreamWorld.frontDefault ??
        response.sprites.other.home.frontDefault ?? ""
        
        let newPokemon = PokemonDomainModel(
            id: response.id,
            name: response.name,
            image: image,
            height: Float(response.height) / 10.0,
            weight: Float(response.weight) / 10.0,
            baseExp: response.baseExperience,
            baseStat: response.stats.map { statResponse in
                
                let newBaseStat = BaseStat(
                    name: statResponse.stat.name,
                    effort: statResponse.effort,
                    value: statResponse.baseStat,
                    url: statResponse.stat.url)
                
                return newBaseStat
                
            },
            moves: response.moves.map { moveResponse in
                return moveResponse.move.name
            },
            type: response.types.map { typeResponse in
                return typeResponse.type.name
            },
            abilities: response.abilities.map { ability in
                ability.ability.name.capitalized
            }.joined(separator: ", "),
            offset: response.offset
        )
        
        return newPokemon
    }
    
    public func transformDomainToEntity(domain: PokemonDomainModel) -> PokemonEntity {
        let pokemonEntity = PokemonEntity()
        let baseStat = List<BaseStatEntity>()
        baseStat.append(
            objectsIn:
                domain.baseStat.map {
                    let baseStatEntity = BaseStatEntity()
                    baseStatEntity.name = $0.name
                    baseStatEntity.effort = $0.effort
                    baseStatEntity.url = $0.url
                    baseStatEntity.value = $0.value
                    return baseStatEntity
                }
        )
        
        pokemonEntity.id = domain.id
        pokemonEntity.name = domain.name
        pokemonEntity.image = domain.image
        pokemonEntity.height = domain.height
        pokemonEntity.weight = domain.weight
        pokemonEntity.baseExp = domain.baseExp
        pokemonEntity.baseStat = baseStat
        pokemonEntity.moves = domain.moves.joined(separator: ",")
        pokemonEntity.type = domain.type.joined(separator: ",")
        pokemonEntity.abilities = domain.abilities
        pokemonEntity.isFavorite = domain.isFavorite
        pokemonEntity.offset = domain.offset
        
        return pokemonEntity
    }
    
    
}
