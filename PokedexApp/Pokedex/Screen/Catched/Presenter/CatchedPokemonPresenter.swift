//
//  CatchedPokemonPresenter.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import Foundation


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
    
    
    var view: CatchedPokemonViewProtocol? { get set }
    
    var isLoadingData: Bool { get set }
    func getSearchPokemon(query: String?)
    func didSelectPokemonItem(with pokemon: CatchPokemonDomainModel)
    func saveToggleFavorite(pokemon: CatchPokemonDomainModel)
}

class CatchedPokemonPresenter: CatchedPokemonPresenterProtocol {
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
                self?.view?.updatePokemonFavorite(with: pokemonResults)
            } onError: { error in
                self.view?.updatePokemonFavorite(with: error.localizedDescription)
            } onCompleted: {
                self.isLoadingData = false
            }.disposed(by: disposeBag)
    }
    
    func didSelectPokemonItem(with pokemon: CatchPokemonDomainModel) {
        //        router?.gotoDetailPokemon(with: pokemon)
    }
    
    func saveToggleFavorite(pokemon: CatchPokemonDomainModel) {
        putCatchPokemonInteractor?.execute(request: pokemon)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] state in
                self?.view?.updateSaveToggleFavorite(with: state )
            } onError: { error in
                self.view?.updateSaveToggleFavorite(with: error.localizedDescription)
            } onCompleted: {
                self.isLoadingData = false
            }.disposed(by: disposeBag)
    }
}
