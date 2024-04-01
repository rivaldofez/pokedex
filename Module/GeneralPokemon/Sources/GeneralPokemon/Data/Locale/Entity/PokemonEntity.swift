//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import RealmSwift

public class PokemonEntity: Object {
    @Persisted(primaryKey: true) public var id: Int
    @Persisted public var name: String
    @Persisted public var image: String
    @Persisted public var height: Float
    @Persisted public var weight: Float
    @Persisted public var baseExp: Int
    @Persisted public var baseStat: List<BaseStatEntity>
    @Persisted public var moves: String
    @Persisted public var type: String
    @Persisted public var abilities: String
    @Persisted public var isFavorite: Bool
    @Persisted public var offset: Int
}

public class BaseStatEntity: Object {
    @Persisted public var name: String
    @Persisted public var effort: Int
    @Persisted public var value: Int
    @Persisted public var url: String
}
