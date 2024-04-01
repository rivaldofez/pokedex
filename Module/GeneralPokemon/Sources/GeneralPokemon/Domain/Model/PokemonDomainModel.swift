//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import Foundation

public struct PokemonDomainModel: Identifiable {
    
    public init(
        id: Int,
        name: String,
        image: String,
        height: Float,
        weight: Float,
        baseExp: Int,
        baseStat: [BaseStat],
        moves: [String],
        type: [String],
        abilities: String,
        isFavorite: Bool = false,
        offset: Int = 0
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.height = height
        self.weight = weight
        self.baseExp = baseExp
        self.baseStat = baseStat
        self.moves = moves
        self.type = type
        self.abilities = abilities
        self.isFavorite = isFavorite
        self.offset = offset
    }
    
    public let id: Int
    public let name: String
    public let image: String
    public let height: Float
    public let weight: Float
    public let baseExp: Int
    public let baseStat: [BaseStat]
    public let moves: [String]
    public let type: [String]
    public let abilities: String
    public var isFavorite: Bool = false
    public var offset: Int = 0
}

public struct BaseStat {
    
    public init(
        name: String,
        effort: Int,
        value: Int,
        url: String
    ) {
        self.name = name
        self.effort = effort
        self.value = value
        self.url = url
    }
    
    public let name: String
    public let effort: Int
    public let value: Int
    public let url: String
}

