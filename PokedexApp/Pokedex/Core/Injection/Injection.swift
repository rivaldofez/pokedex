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
import CatchPokemon


typealias PokemonInteractor = Core.Interactor<Int, GeneralPokemon.PokemonDomainModel, GeneralPokemon.GetPokemonRepository<GeneralPokemon.PokemonLocaleDataSource, GeneralPokemon.PokemonTransformer>>

typealias ReleaseCatchPokemonInteractor = Core.Interactor<CatchPokemon.CatchPokemonDomainModel?, Bool, CatchPokemon.ReleaseCatchPokemonRepository<CatchPokemon.CatchPokemonLocaleDataSource, CatchPokemon.CatchPokemonTransformer>>

typealias PutCatchPokemonInteractor = Core.Interactor<CatchPokemonDomainModel?,Bool,PutCatchPokemonRepository<CatchPokemonLocaleDataSource,CatchPokemonTransformer>>

typealias GetCatchPokemonInteractor = Core.Interactor<String, [CatchPokemon.CatchPokemonDomainModel], CatchPokemon.GetCatchPokemonRepository<CatchPokemon.CatchPokemonLocaleDataSource, CatchPokemon.CatchPokemonsTransformer>>

typealias PokemonSpeciesInteractor = Core.Interactor<Int, SpeciesPokemon.PokemonSpeciesDomainModel?, SpeciesPokemon.GetPokemonSpeciesRepository<SpeciesPokemon.PokemonSpeciesLocaleDataSource, SpeciesPokemon.PokemonSpeciesRemoteDataSource, SpeciesPokemon.PokemonSpeciesTransformer>>

typealias PokemonsInteractor = Interactor<Int, [PokemonDomainModel], GetPokemonsRepository<PokemonLocaleDataSource, PokemonRemoteDataSource, PokemonsTransformer>>

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
    
    func providePokemonSpecies<U: UseCase>() -> U where U.Request == Int, U.Response == PokemonSpeciesDomainModel? {
        
        let locale = PokemonSpeciesLocaleDataSource(realm: realm!)
        let remote = PokemonSpeciesRemoteDataSource(endpoint: { Endpoints.Gets.pokemonSpecies($0).url })
        
        let mapper = PokemonSpeciesTransformer()
         
        let repository = GetPokemonSpeciesRepository(
          localeDataSource: locale,
          remoteDataSource: remote,
          mapper: mapper)
        
        return Interactor(repository: repository) as! U
    }
    
    func providePutCatchPokemon<U: UseCase>() -> U where U.Request == CatchPokemonDomainModel?, U.Response == Bool {
        
        let locale = CatchPokemonLocaleDataSource(realm: realm!)
        let mapper = CatchPokemonTransformer()
        
        let repository = PutCatchPokemonRepository(localeDataSource: locale, mapper: mapper)
        return Interactor(repository: repository) as! U
        
    }
    
    func provideGetCatchPokemon<U: UseCase>() -> U where U.Request == String, U.Response == [CatchPokemonDomainModel] {
        
        let locale = CatchPokemonLocaleDataSource(realm: realm!)
        let mapper = CatchPokemonsTransformer()
        
        let repository = GetCatchPokemonRepository(localeDataSource: locale, mapper: mapper)
        return Interactor(repository: repository) as! U
        
    }
    
    func provideReleaseCatchPokemon<U: UseCase>() -> U where U.Request == CatchPokemonDomainModel?, U.Response == Bool {
        
        let locale = CatchPokemonLocaleDataSource(realm: realm!)
        let mapper = CatchPokemonTransformer()
        
        let repository = ReleaseCatchPokemonRepository(localeDataSource: locale, mapper: mapper)
        return Interactor(repository: repository) as! U
    }
}
