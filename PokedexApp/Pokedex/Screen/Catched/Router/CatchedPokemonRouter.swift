//
//  CatchedPokemonRouter.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import GeneralPokemon
import CatchPokemon
import Foundation

protocol CatchedPokemonRouterProtocol {
    var entry: CatchedPokemonViewController? { get set }
    
    static func createCatched() -> CatchedPokemonRouterProtocol
    
    func gotoDetailPokemon(with pokemon: PokemonDomainModel )
}

class CatchedPokemonRouter: CatchedPokemonRouterProtocol {
    var entry: CatchedPokemonViewController?
    
    static func createCatched() -> CatchedPokemonRouterProtocol {
        let router = CatchedPokemonRouter()
    
        var view: CatchedPokemonViewProtocol = CatchedPokemonViewController()
        var presenter: CatchedPokemonPresenterProtocol = CatchedPokemonPresenter()
        
        view.presenter = presenter
        presenter.router = router
        presenter.view = view
        presenter.getCatchPokemonInteractor = Injection().provideGetCatchPokemon()
        presenter.putCatchPokemonInteractor = Injection().providePutCatchPokemon()
        presenter.releaseCatchPokemonInteractor = Injection().provideReleaseCatchPokemon()
        
        router.entry = view as? CatchedPokemonViewController
        
        return router
    }
    
    func gotoDetailPokemon(with pokemon: PokemonDomainModel) {
        let detailPokemonRouter = DetailPokemonRouter.createDetailPokemon(with: pokemon)
        guard let detailPokemonView = detailPokemonRouter.entry else { return }
        guard let viewController = self.entry else { return }
        
        viewController.hidesBottomBarWhenPushed = true
        viewController.navigationController?.pushViewController(detailPokemonView, animated: true)
        viewController.hidesBottomBarWhenPushed = false
    }
}
