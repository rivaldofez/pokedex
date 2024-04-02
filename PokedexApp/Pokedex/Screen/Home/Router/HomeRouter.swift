//
//  HomeRouter.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import Foundation

import UIKit
import Core
import GeneralPokemon

typealias EntryPoint = HomeViewProtocol & UIViewController

protocol HomeRouterProtocol {
    var entry: EntryPoint? { get }
    
    static func start() -> HomeRouterProtocol
    
    func gotoDetailPokemon(with pokemon: PokemonDomainModel )
}

class HomeRouter: HomeRouterProtocol {
    var entry: EntryPoint?
    
    static func start() -> HomeRouterProtocol {
        let router = HomeRouter()
        
        var view: HomeViewProtocol = HomeViewController()
        let interactor: Interactor<
            Int,
            [PokemonDomainModel],
            GetPokemonsRepository<
                PokemonLocaleDataSource,
                PokemonRemoteDataSource,
                PokemonsTransformer>> = Injection().providePokemons()
            
        let presenter = HomePokemonPresenter()
        
        view.presenter = presenter
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
    func gotoDetailPokemon(with pokemon: PokemonDomainModel) {
//        let detailPokemonRouter = DetailPokemonRouter.createDetailPokemon(with: pokemon)
//        guard let detailPokemonView = detailPokemonRouter.entry else { return }
//        guard let viewController = self.entry else { return }
//        
//        viewController.hidesBottomBarWhenPushed = true
//        viewController.navigationController?.pushViewController(detailPokemonView, animated: true)
//        viewController.hidesBottomBarWhenPushed = false
    }
}
