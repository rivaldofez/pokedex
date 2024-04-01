//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import Foundation

public struct PokemonSpeciesResponse: Codable {
    public let baseHappiness: Int
    public let captureRate: Int
    public let color: BridgeComponent
    public let eggGroups: [BridgeComponent]
    public let flavorTextEntries: [FlavorTextEntry]
    public let genderRate: Int
    public let genera: [Genus]
    public let growthRate: BridgeComponent
    public let habitat: BridgeComponent?
    public let hatchCounter: Int
    public let id: Int
    public let isBaby, isLegendary, isMythical: Bool
    public let name: String
    public let shape: BridgeComponent
    public let varieties: [Variety]
    
    public enum CodingKeys: String, CodingKey {
        case baseHappiness = "base_happiness"
         case captureRate = "capture_rate"
         case color
         case eggGroups = "egg_groups"
         case flavorTextEntries = "flavor_text_entries"
         case genderRate = "gender_rate"
         case genera
         case growthRate = "growth_rate"
         case habitat
         case hatchCounter = "hatch_counter"
         case id
         case isBaby = "is_baby"
         case isLegendary = "is_legendary"
         case isMythical = "is_mythical"
         case name
         case shape, varieties
    }
}

public struct EvolutionChain: Codable {
    public let url: String
}

public struct FlavorTextEntry: Codable {
    public let flavorText: String
    public let language, version: BridgeComponent
    
    public enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language, version
    }
}

public struct Genus: Codable {
    public let genus: String
    public let language: BridgeComponent
}

public struct Name: Codable {
    public let language: BridgeComponent
    public let name: String
}

public struct PalParkEncounter: Codable {
    public let area: BridgeComponent
    public let baseScore, rate: Int
    
    public enum CodingKeys: String, CodingKey {
         case area
         case baseScore = "base_score"
         case rate
    }
}

public struct PokedexNumber: Codable {
    public let entryNumber: Int
    public let pokedex: BridgeComponent
    
    public enum CodingKeys: String, CodingKey {
         case entryNumber = "entry_number"
         case pokedex
    }
}

public struct Variety: Codable {
    public let isDefault: Bool
    public let pokemon: BridgeComponent
    
    public enum CodingKeys: String, CodingKey {
         case isDefault = "is_default"
         case pokemon
    }
}

public struct BridgeComponent: Codable {
    public let name: String
    public let url: String
}
