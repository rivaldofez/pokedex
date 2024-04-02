//
//  Injection.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import Foundation
import RealmSwift
import Core
import SpeciesPokemon
import GeneralPokemon

final class Injection: NSObject {
    private let realm = try? Realm()
            
    func providePokemon<U: UseCase>() -> U where U.Request == Int, U.Response == PokemonDomainModel {
        
        let locale = PokemonLocaleDataSource(realm: realm!)
        let mapper = PokemonTransformer()
        
        let repository = GetPokemonRepository(localeDataSource: locale, mapper: mapper)
        
        return Interactor(repository: repository) as! U
    }
    
    func providePokemons<U: UseCase>() -> U where U.Request == Int, U.Response == [PokemonDomainModel] {
        
        let locale = PokemonLocaleDataSource(realm: realm!)
        let remote = PokemonRemoteDataSource {
            Endpoints.Gets.pokemon($0).url
        }
        
        let mapper = PokemonsTransformer()
        
        let repository = GetPokemonsRepository(localeDataSource: locale, remoteDataSource: remote, mapper: mapper)
        
        return Interactor(repository: repository) as! U
    }
}
