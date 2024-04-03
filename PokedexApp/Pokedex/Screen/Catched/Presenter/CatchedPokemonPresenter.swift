//
//  CatchedPokemonPresenter.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import Foundation
import GeneralPokemon
import Core
import CatchPokemon
import RxSwift

protocol CatchedPokemonPresenterProtocol {
    var router: CatchedPokemonRouterProtocol? { get set }
    
    var getCatchPokemonInteractor: Interactor<
        String,
        [CatchPokemonDomainModel],
        GetCatchPokemonRepository<
            CatchPokemonLocaleDataSource,
            CatchPokemonsTransformer>>? { get set }
    
    var putCatchPokemonInteractor: Interactor<
        CatchPokemonDomainModel?,
        Bool,
        PutCatchPokemonRepository<
            CatchPokemonLocaleDataSource,
            CatchPokemonTransformer>>? { get set }
    
    var releaseCatchPokemonInteractor: Interactor<
        CatchPokemonDomainModel?,
        Bool,
        ReleaseCatchPokemonRepository<
            CatchPokemonLocaleDataSource,
            CatchPokemonTransformer>>? { get set }
    
    var pokemonInteractor: Interactor<
        Int,
        PokemonDomainModel,
        GetPokemonRepository<
            PokemonLocaleDataSource,
            PokemonTransformer>>? { get set }
    
    
    var view: CatchedPokemonViewProtocol? { get set }
    
    var isLoadingData: Bool { get set }
    func getSearchPokemon(query: String?)
    func didSelectPokemonItem(with pokemon: CatchPokemonDomainModel)
    func releaseCatchPokemon(with pokemon: CatchPokemonDomainModel)
    func putUpdateCatchPokemon(with pokemon: CatchPokemonDomainModel)
}

class CatchedPokemonPresenter: CatchedPokemonPresenterProtocol {
    var pokemonInteractor: Core.Interactor<Int, GeneralPokemon.PokemonDomainModel, GeneralPokemon.GetPokemonRepository<GeneralPokemon.PokemonLocaleDataSource, GeneralPokemon.PokemonTransformer>>?
    
    var releaseCatchPokemonInteractor: Core.Interactor<CatchPokemon.CatchPokemonDomainModel?, Bool, CatchPokemon.ReleaseCatchPokemonRepository<CatchPokemon.CatchPokemonLocaleDataSource, CatchPokemon.CatchPokemonTransformer>>?
    
    var getCatchPokemonInteractor: Core.Interactor<String, [CatchPokemon.CatchPokemonDomainModel], CatchPokemon.GetCatchPokemonRepository<CatchPokemon.CatchPokemonLocaleDataSource, CatchPokemon.CatchPokemonsTransformer>>?
    
    var putCatchPokemonInteractor: Core.Interactor<CatchPokemon.CatchPokemonDomainModel?, Bool, CatchPokemon.PutCatchPokemonRepository<CatchPokemon.CatchPokemonLocaleDataSource, CatchPokemon.CatchPokemonTransformer>>?
    
    private let disposeBag = DisposeBag()
    
    var router: CatchedPokemonRouterProtocol?
    
    var view: CatchedPokemonViewProtocol?
    
    var isLoadingData: Bool = false {
        didSet {
            view?.isLoadingData(with: isLoadingData)
        }
    }
    
    func getSearchPokemon(query: String?) {
        self.isLoadingData = true
        
        getCatchPokemonInteractor?.execute(request: query)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] pokemonResults in
                self?.view?.updateMyPokemon(with: pokemonResults)
            } onError: { error in
                self.view?.updateMyPokemon(with: error.localizedDescription)
            } onCompleted: {
                self.isLoadingData = false
            }.disposed(by: disposeBag)
    }
    
    func didSelectPokemonItem(with pokemon: CatchPokemonDomainModel) {
        pokemonInteractor?.execute(request: pokemon.id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] pokemonResult in
                self?.router?.gotoDetailPokemon(with: pokemonResult)
            }
            .disposed(by: disposeBag)
    }
    
    func putUpdateCatchPokemon(with pokemon: CatchPokemonDomainModel) {
        putCatchPokemonInteractor?.execute(request: pokemon)
            .subscribe { [weak self] state in
                self?.view?.updateEditPokemon(with: state)
            } onError: { error in
                self.view?.updateEditPokemon(with: error.localizedDescription)
            } onCompleted: {
                self.isLoadingData = false
            }.disposed(by: disposeBag)
    }
    
    func releaseCatchPokemon(with pokemon: CatchPokemonDomainModel) {
        releaseCatchPokemonInteractor?.execute(request: pokemon)
            .subscribe { [weak self] state in
                self?.view?.updateReleasePokemon(with: state )
            } onError: { error in
                self.view?.updateReleasePokemon(with: error.localizedDescription)
            } onCompleted: {
                self.isLoadingData = false
            }.disposed(by: disposeBag)
    }
}
