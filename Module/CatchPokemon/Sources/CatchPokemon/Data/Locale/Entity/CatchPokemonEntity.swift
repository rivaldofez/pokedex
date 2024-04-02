//
//  File.swift
//  
//
//  Created by rivaldo on 02/04/24.
//

import RealmSwift
import Foundation

public class CatchPokemonEntity: Object {
    @Persisted(primaryKey: true) public var catchId: String
    @Persisted public var id: Int
    @Persisted public var name: String
    @Persisted public var nickname: String
    @Persisted public var image: String
    @Persisted public var type: String
    @Persisted public var catchDate: Date
}
