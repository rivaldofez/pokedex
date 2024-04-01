//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import RealmSwift

public class PokemonSpeciesEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var baseHappines: Int
    @Persisted var captureRate: Int
    @Persisted var color: String
    @Persisted var about: String
    @Persisted var genderRate: String
    @Persisted var genus: String
    @Persisted var growthRate: String
    @Persisted var habitat: String
    @Persisted var hatchCounter: Int
    @Persisted var isLegendary: Bool
    @Persisted var isMythical: Bool
    @Persisted var isBaby: Bool
    @Persisted var shape: String
    @Persisted var eggGroups: String
}
