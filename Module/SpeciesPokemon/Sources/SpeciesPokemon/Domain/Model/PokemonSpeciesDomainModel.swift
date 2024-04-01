//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import Foundation

public struct PokemonSpeciesDomainModel: Identifiable {
    public let id: Int
    public let baseHappines: Int
    public let captureRate: Int
    public let color: String
    public let about: String
    public let genderRate: String
    public let genus: String
    public let growthRate: String
    public let habitat: String
    public let hatchCounter: Int
    public let isLegendary: Bool
    public let isMythical: Bool
    public let isBaby: Bool
    public let shape: String
    public let eggGroups: String
    
    public init(id: Int, baseHappines: Int, captureRate: Int, color: String, about: String, genderRate: String, genus: String, growthRate: String, habitat: String, hatchCounter: Int, isLegendary: Bool, isMythical: Bool, isBaby: Bool, shape: String, eggGroups: String) {
        
        self.id = id
        self.baseHappines = baseHappines
        self.captureRate = captureRate
        self.color = color
        self.about = about
        self.genderRate = genderRate
        self.genus = genus
        self.growthRate = growthRate
        self.habitat = habitat
        self.hatchCounter = hatchCounter
        self.isLegendary = isLegendary
        self.isMythical = isMythical
        self.isBaby = isBaby
        self.shape = shape
        self.eggGroups = eggGroups
    }
}
