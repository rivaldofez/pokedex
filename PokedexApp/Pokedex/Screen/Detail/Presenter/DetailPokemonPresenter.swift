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
    func putCatchedPokemon(pokemon: PokemonDomainModel, nickname: String)
    func catchProbState() -> Bool
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
                    self?.view?.updatePokemonSpecies(with: "msg.error.retrieve.detail.pokemon".localized())
                }
            } onError: { error in
                self.view?.updatePokemonSpecies(with: error.localizedDescription)
            } onCompleted: {
                self.isLoadingData = false
            }.disposed(by: disposeBag)
        
    }
    
    func getPokemon(with pokemon: PokemonDomainModel) {
        isLoadingData = true
        self.view?.updatePokemon(with: pokemon)
        self.getPokemonSpecies(id: pokemon.id)
    }
    
    func putCatchedPokemon(pokemon: PokemonDomainModel, nickname: String) {
        self.isLoadingData = true
        
        let catchModel = CatchPokemonDomainModel(catchId: UUID().uuidString, id: pokemon.id, name: pokemon.name, nickname: nickname.isEmpty ? pokemon.name.capitalized : nickname, image: pokemon.image, type: pokemon.type, catchDate: Date())
        
        putCatchPokemonInteractor?.execute(request: catchModel)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] state in
                self?.view?.updatePutCatchPokemonResult(with: state)
            } onError: { error in
                self.view?.updatePutCatchPokemonResult(with: error.localizedDescription)
            } onCompleted: {
                self.isLoadingData = false
            }.disposed(by: disposeBag)
    }
    
    func catchProbState() -> Bool {
        let rand = Double.random(in: 0..<1)
        return rand < 0.5
    }
}
