//
//  DetailPresenter.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import Foundation
import Core
import GeneralPokemon
import SpeciesPokemon
import Common
import RxSwift
import CatchPokemon

protocol DetailPokemonPresenterProtocol {
    var router: DetailPokemonRouterProtocol? { get set}
    
    var speciesInteractor: Interactor<
        Int,
        PokemonSpeciesDomainModel?,
        GetPokemonSpeciesRepository<
            PokemonSpeciesLocaleDataSource,
            PokemonSpeciesRemoteDataSource,
            PokemonSpeciesTransformer>>? { get set }
    
    var putCatchPokemonInteractor: Interactor<
        CatchPokemonDomainModel?,
        Bool,
        PutCatchPokemonRepository<
            CatchPokemonLocaleDataSource,
            CatchPokemonTransformer>>? { get set }
    
//    var toggleFavoriteInteractor: Interactor<
//        PokemonDomainModel,
//        Bool,
//        ToggleFavoritePokemonRepository<
//            PokemonLocaleDataSource,
//            PokemonTransformer>>? { get set }
    
    var pokemonInteractor: Interactor<
        Int,
        PokemonDomainModel,
        GetPokemonRepository<
            PokemonLocaleDataSource,
            PokemonTransformer>>? { get set }
    
    var view: DetailPokemonViewProtocol? { get set }
    
    var isLoadingData: Bool { get set}
    
    func getPokemonSpecies(id: Int)
    func getPokemon(with pokemon: PokemonDomainModel)
    func saveToggleFavorite(pokemon: PokemonDomainModel)
}

class DetailPokemonPresenter: DetailPokemonPresenterProtocol {
    var putCatchPokemonInteractor: Core.Interactor<CatchPokemon.CatchPokemonDomainModel?, Bool, CatchPokemon.PutCatchPokemonRepository<CatchPokemon.CatchPokemonLocaleDataSource, CatchPokemon.CatchPokemonTransformer>>?
    
    var pokemonInteractor: Interactor<Int, PokemonDomainModel, GetPokemonRepository<PokemonLocaleDataSource, PokemonTransformer>>?
    
    private let disposeBag = DisposeBag()
    
    var router: DetailPokemonRouterProtocol?
    
    var speciesInteractor: Core.Interactor<Int, SpeciesPokemon.PokemonSpeciesDomainModel?, SpeciesPokemon.GetPokemonSpeciesRepository<SpeciesPokemon.PokemonSpeciesLocaleDataSource, SpeciesPokemon.PokemonSpeciesRemoteDataSource, SpeciesPokemon.PokemonSpeciesTransformer>>?
    
    var view: DetailPokemonViewProtocol?
    
    var isLoadingData: Bool = false {
        didSet {
            view?.isLoadingData(with: isLoadingData)
        }
    }
    
    func getPokemonSpecies(id: Int) {
        isLoadingData = true
        
        speciesInteractor?.execute(request: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] pokemonSpeciesResult in
                if let pokemonSpecies = pokemonSpeciesResult {
                    self?.view?.updatePokemonSpecies(with: pokemonSpecies)
                } else {
                    self?.view?.updatePokemonSpecies(with: "msg.error.retrieve.detail.pokemon".localized(bundle: commonBundle))
                }
            } onError: { error in
                self.view?.updatePokemonSpecies(with: error.localizedDescription)
            } onCompleted: {
                self.isLoadingData = false
            }.disposed(by: disposeBag)
        
    }
    
    func getPokemon(with pokemon: PokemonDomainModel) {
        isLoadingData = true
        
        pokemonInteractor?.execute(request: pokemon.id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] pokemonResult in
                self?.view?.updatePokemon(with: pokemonResult)
            } onError: { _ in
                self.view?.updatePokemon(with: pokemon)
                self.getPokemonSpecies(id: pokemon.id)
            } onCompleted: {
                self.getPokemonSpecies(id: pokemon.id)
            }.disposed(by: disposeBag)
    }
    
    func saveToggleFavorite(pokemon: PokemonDomainModel) {
        self.isLoadingData = true
        
        let catchModel = CatchPokemonDomainModel(catchId: UUID().uuidString, id: pokemon.id, name: pokemon.name, nickname: "Nickname", image: pokemon.image, type: pokemon.type, catchDate: Date())
        
        putCatchPokemonInteractor?.execute(request: catchModel)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.view?.updateSaveToggleFavorite(with: pokemon.isFavorite)
            } onError: { error in
                self.view?.updateSaveToggleFavorite(with: error.localizedDescription)
            } onCompleted: {
                self.isLoadingData = false
            }.disposed(by: disposeBag)
    }
}
