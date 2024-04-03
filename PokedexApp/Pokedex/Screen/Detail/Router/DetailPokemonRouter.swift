//
//  DetailPokemonRouter.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import Foundation
import GeneralPokemon
import Core
import SpeciesPokemon

protocol DetailPokemonRouterProtocol {
    var entry: DetailPokemonViewController? { get }
    
    static func createDetailPokemon(with pokemon: PokemonDomainModel, nickname: String?) -> DetailPokemonRouterProtocol
}

class DetailPokemonRouter: DetailPokemonRouterProtocol {
    var entry: DetailPokemonViewController?
    
    static func createDetailPokemon(with pokemon: PokemonDomainModel, nickname: String? = nil) -> DetailPokemonRouterProtocol {
        
        let router = DetailPokemonRouter()
        var view: DetailPokemonViewProtocol = DetailPokemonViewController()
        let interactor: Interactor<
            Int,
            PokemonSpeciesDomainModel?,
            GetPokemonSpeciesRepository<
                PokemonSpeciesLocaleDataSource,
                PokemonSpeciesRemoteDataSource,
                PokemonSpeciesTransformer>>? = Injection().providePokemonSpecies()
        
        var presenter: DetailPokemonPresenterProtocol = DetailPokemonPresenter()
        
        view.presenter = presenter
        presenter.router = router
        presenter.view = view
        presenter.speciesInteractor = interactor
        presenter.putCatchPokemonInteractor = Injection().providePutCatchPokemon()
        presenter.pokemonInteractor = Injection().providePokemon()
        
        presenter.getPokemon(with: pokemon, nickname: nickname)
        router.entry = view as? DetailPokemonViewController
        
        return router
    }
}
