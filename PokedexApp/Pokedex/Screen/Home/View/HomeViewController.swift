//
//  HomeViewController.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import UIKit
import RxSwift
import Lottie
import GeneralPokemon
import Common

protocol HomeViewProtocol {
    var presenter: HomePresenterProtocol? { get set }
    
    func updatePokemon(with pokemons: [PokemonDomainModel])
    func updatePokemon(with error: String)
    func isLoadingData(with state: Bool)
}

class HomeViewController: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol?
    
    private var pokemonDataPagination: [PokemonDomainModel] = []
    private let disposeBag = DisposeBag()
    
    // MARK: View Components
    // Pokemon Collection View
    private lazy var pokemonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: ((view.frame.size.width) / 3) - 10, height: (view.frame.size.width) / 2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionView
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
        label.text = "msg.error.load.pokemon".localized(bundle: commonBundle)
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
    
    private lazy var retryButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(reloadData), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var errorStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [errorAnimation, errorLabel, retryButton])
        stackview.axis = .vertical
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.alignment = .center
        stackview.spacing = 16
        stackview.isHidden = true
        return stackview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pokémon"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
        
        view.backgroundColor = .systemBackground
        view.addSubview(pokemonCollectionView)
        view.addSubview(errorStackView)
        view.addSubview(backdropLoading)
        view.addSubview(loadingAnimation)
        
        pokemonCollectionView.delegate = self
        pokemonCollectionView.dataSource = self
        
        configureConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pokemonCollectionView.frame = view.bounds
        backdropLoading.frame = view.bounds
    }
    
    // MARK: Auto Layout Constraints
    private func configureConstraints() {
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
    }
    
    // MARK: Presenter Action
    
    func isLoadingData(with state: Bool) {
        showLoading(isLoading: state)
    }
    
    func updatePokemon(with pokemons: [PokemonDomainModel]) {
        DispatchQueue.main.async {
            self.pokemonDataPagination.append(contentsOf: pokemons)
            self.pokemonCollectionView.reloadData()
            self.showError(isError: false)
        }
    }
    
    func updatePokemon(with error: String) {
        showError(isError: true)
    }
    
    // MARK: Button Action
    
    @objc private func reloadData() {
        if let offset = presenter?.offsetPagination {
            presenter?.getPokemonPagination(offset: offset)
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
    
    private func showError(isError: Bool) {
        UIView.transition(with: errorStackView, duration: 0.4, options: .transitionCrossDissolve) {
            self.errorStackView.isHidden = !isError
        }
        
        UIView.transition(with: pokemonCollectionView, duration: 0.4, options: .transitionCrossDissolve) {
            self.pokemonCollectionView.isHidden = isError
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerview = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        footerview.addSubview(spinner)
        spinner.center = footerview.center
        spinner.startAnimating()
        
        return footerview
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonDataPagination.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as? PokemonCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let model = pokemonDataPagination[indexPath.item]
        cell.configure(with: model)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (pokemonCollectionView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            guard let isLoadingData = presenter?.isLoadingData else { return }
            if !isLoadingData {
                guard let offsetPagination = presenter?.offsetPagination else { return }
                
                presenter?.offsetPagination = offsetPagination + 50
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectPokemonItem(with: pokemonDataPagination[indexPath.item])
    }
}
