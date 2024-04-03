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
    
    var getCatchPokemonInteractor: GetCatchPokemonInteractor? { get set }
    var putCatchPokemonInteractor: PutCatchPokemonInteractor? { get set }
    var releaseCatchPokemonInteractor: ReleaseCatchPokemonInteractor? { get set }
    var pokemonInteractor:PokemonInteractor? { get set }
    
    var view: CatchedPokemonViewProtocol? { get set }
    
    var isLoadingData: Bool { get set }
    func getSearchPokemon(query: String?)
    func didSelectPokemonItem(with pokemon: CatchPokemonDomainModel)
    func releaseCatchPokemon(with pokemon: CatchPokemonDomainModel)
    func putUpdateCatchPokemon(with pokemon: CatchPokemonDomainModel)
}

class CatchedPokemonPresenter: CatchedPokemonPresenterProtocol {
    var pokemonInteractor: PokemonInteractor?
    
    var releaseCatchPokemonInteractor: ReleaseCatchPokemonInteractor?
    
    var getCatchPokemonInteractor: GetCatchPokemonInteractor?
    
    var putCatchPokemonInteractor: PutCatchPokemonInteractor?
    
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
                self?.router?.gotoDetailPokemon(with: pokemonResult, nickname: pokemon.nickname)
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
