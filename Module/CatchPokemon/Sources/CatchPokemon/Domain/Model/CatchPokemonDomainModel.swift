//
//  File.swift
//  
//
//  Created by rivaldo on 02/04/24.
//

import Foundation

public class CatchPokemonDomainModel: Identifiable {
    public var catchId: String
    public var id: Int
    public var name: String
    public var nickname: String
    public var image: String
    public var type: [String]
    public var catchDate: Date

    public init(
        catchId: String,
        id: Int,
        name: String,
        nickname: String,
        image: String,
        type: [String],
        catchDate: Date
    ) {
        self.catchId = catchId
        self.id = id
        self.name = name
        self.nickname = nickname
        self.image = image
        self.type = type
        self.catchDate = catchDate
    }
}
