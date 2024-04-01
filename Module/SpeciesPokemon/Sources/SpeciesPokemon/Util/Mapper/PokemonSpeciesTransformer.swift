//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import Core

public struct PokemonSpeciesTransformer: Mapper {
    public func transformResponseToEntity(response: PokemonSpeciesResponse?) -> PokemonSpeciesEntity? {
        
        if let response = response {
            let pokeSpeciesEntity = PokemonSpeciesEntity()
            pokeSpeciesEntity.id = response.id
            pokeSpeciesEntity.baseHappines = response.baseHappiness
            pokeSpeciesEntity.captureRate = response.captureRate
            pokeSpeciesEntity.color = response.color.name
            pokeSpeciesEntity.about = formatAboutPokemon(flavorTextEntries: response.flavorTextEntries)
            pokeSpeciesEntity.genderRate = formatGenderRate(genderRate: response.genderRate)
            pokeSpeciesEntity.genus = formatGenusPokemon(generaEntries: response.genera)
            pokeSpeciesEntity.growthRate = response.growthRate.name.capitalized
            pokeSpeciesEntity.habitat = response.habitat?.name.capitalized ?? "Unknown"
            pokeSpeciesEntity.hatchCounter = response.hatchCounter
            pokeSpeciesEntity.isLegendary = response.isLegendary
            pokeSpeciesEntity.isMythical = response.isMythical
            pokeSpeciesEntity.isBaby = response.isBaby
            pokeSpeciesEntity.shape = response.shape.name
            pokeSpeciesEntity.eggGroups = formatEggGroup(eggGroups: response.eggGroups)
            
            return pokeSpeciesEntity
        } else {
            return nil
        }
    }
    
    public func transformEntityToDomain(entity: PokemonSpeciesEntity?) -> PokemonSpeciesDomainModel? {
        
        if let entity = entity {
            return PokemonSpeciesDomainModel(
                id: entity.id,
                baseHappines: entity.baseHappines,
                captureRate: entity.captureRate,
                color: entity.color,
                about: entity.about,
                genderRate: entity.genderRate,
                genus: entity.genus,
                growthRate: entity.growthRate,
                habitat: entity.habitat,
                hatchCounter: entity.hatchCounter,
                isLegendary: entity.isLegendary,
                isMythical: entity.isMythical,
                isBaby: entity.isBaby,
                shape: entity.shape,
                eggGroups: entity.eggGroups
            )
        } else {
            return nil
        }
    }
    
    public func transformResponseToDomain(response: PokemonSpeciesResponse?) -> PokemonSpeciesDomainModel? {
        
        if let response = response {
            let newPokemonSpecies = PokemonSpeciesDomainModel(
                id: response.id,
                baseHappines: response.baseHappiness,
                captureRate: response.captureRate,
                color: response.color.name,
                about: formatAboutPokemon(flavorTextEntries: response.flavorTextEntries),
                genderRate: formatGenderRate(genderRate: response.genderRate),
                genus: formatGenusPokemon(generaEntries: response.genera),
                growthRate: response.growthRate.name.capitalized,
                habitat: response.habitat?.name.capitalized ?? "Unknown",
                hatchCounter: response.hatchCounter,
                isLegendary: response.isLegendary,
                isMythical: response.isMythical,
                isBaby: response.isBaby,
                shape: response.shape.name,
                eggGroups: formatEggGroup(eggGroups: response.eggGroups)
            )
            return newPokemonSpecies
        } else {
            return nil
        }
    }
    
    public func transformDomainToEntity(domain: PokemonSpeciesDomainModel?) -> PokemonSpeciesEntity? {
        
        if let domain = domain {
            let pokeSpeciesEntity = PokemonSpeciesEntity()
            pokeSpeciesEntity.id = domain.id
            pokeSpeciesEntity.baseHappines = domain.baseHappines
            pokeSpeciesEntity.captureRate = domain.captureRate
            pokeSpeciesEntity.color = domain.color
            pokeSpeciesEntity.about = domain.about
            pokeSpeciesEntity.genderRate = domain.genderRate
            pokeSpeciesEntity.genus = domain.genus
            pokeSpeciesEntity.growthRate = domain.growthRate
            pokeSpeciesEntity.habitat = domain.habitat
            pokeSpeciesEntity.hatchCounter = domain.hatchCounter
            pokeSpeciesEntity.isLegendary = domain.isLegendary
            pokeSpeciesEntity.isMythical = domain.isMythical
            pokeSpeciesEntity.isBaby = domain.isBaby
            pokeSpeciesEntity.shape = domain.shape
            pokeSpeciesEntity.eggGroups = domain.eggGroups
            
            return pokeSpeciesEntity
        } else {
            return nil
        }
    }
    
    public typealias Response = PokemonSpeciesResponse?
    
    public typealias Entity = PokemonSpeciesEntity?
    
    public typealias Domain = PokemonSpeciesDomainModel?
    
    public init() {}
    
    private func formatAboutPokemon(flavorTextEntries: [FlavorTextEntry]) -> String {
        for flavorEntry in flavorTextEntries
        where flavorEntry.language.name == "en" {
            return flavorEntry.flavorText
                .replacingOccurrences(of: "\n", with: " ")
                .utf8EncodedString()
                .replacingOccurrences(of: "\\014", with: " ")
                .utf8DecodedString()
        }
        
        return ""
    }
    
    private func formatGenusPokemon(generaEntries: [Genus]) -> String {
        for generaEntry in generaEntries
        where generaEntry.language.name == "en" {
            return generaEntry.genus.capitalized
        }
        
        return ""
    }
    
    private func formatEggGroup(eggGroups: [BridgeComponent]) -> String {
        return eggGroups.map { itemEgg in
            return itemEgg.name.capitalized
        }.joined(separator: ", ")
    }
    
    private func formatGenderRate(genderRate: Int) -> String {
        if genderRate == -1 {
            return "Genderless"
        } else {
            let female = (Float(genderRate) / 8.0) * 100
            let male = (Float(8 - genderRate) / 8.0) * 100
            
            return "Male \(male)%, Female \(female)%"
        }
    }
}
