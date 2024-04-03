//
//  CatchedPokemonViewController.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import UIKit
import RxSwift
import Lottie
import GeneralPokemon
import Common
import CatchPokemon

protocol CatchedPokemonViewProtocol {
    var presenter: CatchedPokemonPresenterProtocol? { get set }
    
    func updateMyPokemon(with pokemons: [CatchPokemonDomainModel])
    func updateMyPokemon(with error: String)
    func updateReleasePokemon(with error: String)
    func updateReleasePokemon(with state: Bool)
    func updateEditPokemon(with state: Bool)
    func updateEditPokemon(with error: String)
    func isLoadingData(with state: Bool)
}

class CatchedPokemonViewController: UIViewController, CatchedPokemonViewProtocol {
    var presenter: CatchedPokemonPresenterProtocol?
    
    private var pokemonData: [CatchPokemonDomainModel] = []
    private let disposeBag = DisposeBag()
    
    // MARK: View Components
    // Favorite Table View
    private lazy var pokemonTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(CatchedPokemonTableViewCell.self, forCellReuseIdentifier: CatchedPokemonTableViewCell.identifier)
        return tableView
    }()
    
    // Loading View
    private lazy var loadingAnimation: LottieAnimationView = {
        let lottie = LottieAnimationView(name: "loading")
        lottie.translatesAutoresizingMaskIntoConstraints = false
        lottie.play()
        lottie.loopMode = .loop
        return lottie
    }()
    
    private lazy var backdropLoading: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray.withAlphaComponent(0.3)
        return view
    }()
    
    // Error View
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "msg.error.load.pokemon".localized()
        label.textColor = .label
        label.font = .poppinsBold(size: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var errorAnimation: LottieAnimationView = {
        let lottie = LottieAnimationView(name: "error")
        lottie.translatesAutoresizingMaskIntoConstraints = false
        lottie.heightAnchor.constraint(equalToConstant: 200).isActive = true
        lottie.play()
        lottie.loopMode = .loop
        return lottie
    }()
    
    private lazy var errorStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [errorAnimation, errorLabel])
        stackview.axis = .vertical
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.alignment = .center
        stackview.spacing = 16
        stackview.isHidden = true
        return stackview
    }()
    
    let catchedSearchController: UISearchController = {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.showsScopeBar = true
        searchController.automaticallyShowsCancelButton = true
        searchController.navigationItem.hidesSearchBarWhenScrolling = false
        
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "title.my.pokemon".localized()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
        
        navigationItem.searchController = catchedSearchController
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(pokemonTableView)
        view.addSubview(errorStackView)
        view.addSubview(backdropLoading)
        view.addSubview(loadingAnimation)
        
        pokemonTableView.delegate = self
        pokemonTableView.dataSource = self
        configureConstraints()
        
        catchedSearchController.searchBar.delegate = self
        
    }
    
    // MARK: Auto Layout Constraints
    private func configureConstraints() {
        let pokemonTableViewConstraints = [
            pokemonTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pokemonTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pokemonTableView.topAnchor.constraint(equalTo: view.topAnchor),
            pokemonTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let errorStackViewConstraints = [
            errorStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let loadingAnimationConstraints = [
            loadingAnimation.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingAnimation.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingAnimation.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        NSLayoutConstraint.activate(errorStackViewConstraints)
        NSLayoutConstraint.activate(loadingAnimationConstraints)
        NSLayoutConstraint.activate(pokemonTableViewConstraints)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getSearchPokemon(query: nil)
    }
    
    // MARK: Presenter Action
    func updateReleasePokemon(with error: String) {
        showCommonAlert(title: "title.error.occured".localized(), message: "msg.error.process.request".localized())
        presenter?.getSearchPokemon(query: nil)
    }
    
    func updateReleasePokemon(with state: Bool) {
        showCommonAlert(title: state ? "title.release.pokemon.success".localized() : "title.release.pokemon.failed".localized(), message: state ? "msg.success.released.pokemon".localized() : "msg.failed.released.pokemon".localized() )
    }
    
    func updateEditPokemon(with state: Bool) {
        showCommonAlert(title: state ? "title.edit.nickname.pokemon.success".localized() : "title.edit.nickname.pokemon.failed".localized(), message: state ? "msg.success.edit.nickname.pokemon".localized() : "msg.failed.edit.nickname.pokemon".localized())
    }
    
    func updateEditPokemon(with error: String) {
        showCommonAlert(title: "title.error.occured".localized(), message: "msg.error.process.request".localized())
    }
    
    func updateMyPokemon(with pokemons: [CatchPokemonDomainModel]) {
        if pokemons.isEmpty {
            DispatchQueue.main.async {
                self.pokemonData.removeAll()
                self.pokemonTableView.reloadData()
                self.showError(isError: true, message: "msg.empty.my.pokemon.list".localized(), animation: "empty")
            }
        } else {
            DispatchQueue.main.async {
                self.pokemonData.removeAll()
                self.pokemonData.append(contentsOf: pokemons)
                self.pokemonTableView.reloadData()
                self.showError(isError: false)
            }
        }
    }
    
    func updateMyPokemon(with error: String) {
        showError(isError: true, message: "msg.error.load.pokemon".localized(), animation: "error")
    }
    
    func isLoadingData(with state: Bool) {
        showLoading(isLoading: state)
    }
    
    private func showCommonAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "title.ok".localized(), style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    private func showError(isError: Bool, message: String? = nil, animation: String? = nil ) {
        if let message = message, let animation = animation {
            errorLabel.text = message
            errorAnimation.animation = LottieAnimation.named(animation)
            errorAnimation.play()
        }
        
        UIView.transition(with: errorStackView, duration: 0.4, options: .transitionCrossDissolve) {
            self.errorStackView.isHidden = !isError
        }
        
        UIView.transition(with: pokemonTableView, duration: 0.4, options: .transitionCrossDissolve) {
            self.pokemonTableView.isHidden = isError
        }
    }
    
    private func showLoading(isLoading: Bool) {
        UIView.transition(with: loadingAnimation, duration: 0.4, options: .transitionCrossDissolve) {
            self.loadingAnimation.isHidden = !isLoading
        }
        
        UIView.transition(with: backdropLoading, duration: 0.4, options: .transitionCrossDissolve) {
            self.backdropLoading.isHidden = !isLoading
        }
    }
}

extension CatchedPokemonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pokemonData.count == 0 {
            self.showError(isError: true, message: "msg.empty.my.pokemon.list".localized(), animation: "empty")
        }
        
        return pokemonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatchedPokemonTableViewCell.identifier, for: indexPath) as? CatchedPokemonTableViewCell else { return UITableViewCell() }
        
        let model = pokemonData[indexPath.row]
        cell.configure(with: model)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectPokemonItem(with: pokemonData[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let currentPokemon = self.pokemonData[indexPath.row]
        
        let editAction = UITableViewRowAction(style: .normal, title: "title.edit".localized(), handler: { (action, indexPath) in
            
            let alert = UIAlertController(title: "title.nickname".localized(), message: "msg.choose.new.nickname".localized(), preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.placeholder = currentPokemon.nickname
            }
            
            alert.addAction(UIAlertAction(title: "title.change".localized(), style: .default, handler: { [weak alert] (_) in
                let nickname = alert?.textFields![0].text ?? ""
                if nickname != currentPokemon.nickname {
                    // update nickname
                    currentPokemon.nickname = nickname
                    self.presenter?.putUpdateCatchPokemon(with: currentPokemon)
                    self.pokemonTableView.reloadData()
                }
            }))
            
            alert.addAction(UIAlertAction(title: "title.cancel".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "title.release".localized(), handler: { (action, indexPath) in
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.presenter?.releaseCatchPokemon(with: currentPokemon)
            self.pokemonData.remove(at: indexPath.row)
            tableView.endUpdates()
            
        })
        
        return [deleteAction, editAction]
    }
}

extension CatchedPokemonViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.getSearchPokemon(query: searchText)
    }
}


