//
//  DetailPokemonViewController.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import UIKit
import Lottie
import GeneralPokemon
import SpeciesPokemon
import Common

protocol DetailPokemonViewProtocol {
    var presenter: DetailPokemonPresenterProtocol? { get set }
    
    func updatePokemonSpecies(with pokemonSpecies: PokemonSpeciesDomainModel)
    func updatePokemonSpecies(with error: String)
    func updatePokemon(with pokemon: PokemonDomainModel)
    func updatePutCatchPokemonResult(with error: String)
    func updatePutCatchPokemonResult(with state: Bool)
    func isLoadingData(with state: Bool)
}

class DetailPokemonViewController:
    UIViewController, DetailPokemonViewProtocol {
    
    func updatePutCatchPokemonResult(with error: String) {
        showCommonAlert(title: "title.error.occured".localized(), message: "msg.error.process.request".localized())
    }
    
    func updatePutCatchPokemonResult(with state: Bool) {
        showCommonAlert(title: state ? "title.hooray".localized() : "title.ooops".localized(), message: state ? "msg.pokemon.caught.sent".localized() : "msg.pokemon.caught.not.sent".localized())
    }
    
    var presenter: DetailPokemonPresenterProtocol?
    var aboutSubViewController = AboutSubViewController()
    var baseStatSubViewController = BaseStatSubViewController()
    var movesSubViewController = MovesSubViewController()
    
    var pokemon: PokemonDomainModel?
    
    func updatePokemonSpecies(with pokemonSpecies: PokemonSpeciesDomainModel) {
        aboutSubViewController.pokemonSpecies = pokemonSpecies
        showError(isError: false)
    }
    
    func updatePokemon(with pokemon: PokemonDomainModel) {
        self.pokemon = pokemon
        
        aboutSubViewController.pokemon = pokemon
        baseStatSubViewController.pokemon = pokemon
        movesSubViewController.pokemon = pokemon
        
        guard let url = URL(string: pokemon.image) else { return }
        pokemonImageView.sd_setImage(with: url)
        self.title = pokemon.name.capitalized
        
        pokemon.type.forEach { title in
            chipType.append(configureChip(title: title))
        }
        
        indicator.backgroundColor = UIColor(named: ViewDataConverter.typeStringToColorName(type: pokemon.type.first!))
        showError(isError: false)
    }
    
    func isLoadingData(with state: Bool) {
        showLoading(isLoading: state)
    }
    
    func updatePokemonSpecies(with error: String) {
        showError(isError: true)
    }
    
    private enum SectionTabs: String {
        case about = "About"
        case stat = "Base Stat"
        case moves = "Moves"
        
        var index: Int {
            switch self {
            case .about:
                return 0
            case .stat:
                return 1
            case .moves:
                return 2
            }
        }
        static let allCases = [about, stat, moves]
    }
    
    // MARK: View Components
    // Section Button
    private var sectionTabButtons: [UIButton] = SectionTabs.allCases.map { sectionCase in
        let button = UIButton(type: .system)
        button.setTitle(sectionCase.rawValue, for: .normal)
        button.titleLabel?.font = .poppinsBold(size: 14)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private lazy var sectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: sectionTabButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
    private var selectedTab: Int = 0 {
        didSet {
            for i in 0 ..< sectionTabButtons.count {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
                    self?.sectionStackView.arrangedSubviews[i].tintColor = i == self?.selectedTab ? .label : .secondaryLabel
                    
                    self?.leadingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.trailingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    
                    self?.view.layoutIfNeeded()
                }
            }
        }
    }
    
    private let indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var sectionViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Chip Item
    private lazy var chipType: [UIStackView] = []
    
    private lazy var pokemonTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        for chip in chipType {
            stackView.addArrangedSubview(chip)
        }
        
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        return stackView
    }()
    
    // Pokemon Image
    private let pokemonImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        return imageview
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
        
        view.addSubview(pokemonTypeStackView)
        view.addSubview(pokemonImageView)
        view.addSubview(sectionStackView)
        view.addSubview(indicator)
        view.addSubview(sectionViewContainer)
        view.addSubview(errorStackView)
        view.addSubview(backdropLoading)
        view.addSubview(loadingAnimation)
        addSubViewController(viewController: aboutSubViewController, contentView: sectionViewContainer)
        
        configureConstraints()
        configureStackButton()
        setCatchButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backdropLoading.frame = view.bounds
    }
    
    private func removeSubViewController(viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func addSubViewController(viewController: UIViewController, contentView: UIView) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewController.view)
        
        let matchConstraints = [
            viewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(matchConstraints)
        viewController.didMove(toParent: self)
    }
    
    // MARK: Auto Layout Constraints
    private func configureConstraints() {
        let pokemonImageViewConstraints = [
            pokemonImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            pokemonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImageView.heightAnchor.constraint(equalToConstant: min(view.frame.width/2, view.frame.height/2))
        ]
        
        let pokemonTypeStackViewConstraints = [
            pokemonTypeStackView.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 16),
            pokemonTypeStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        for i in 0 ..< sectionTabButtons.count {
            let leadingAnchor = indicator.leadingAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[i].leadingAnchor)
            leadingAnchors.append(leadingAnchor)
            
            let trailingAnchor = indicator.trailingAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[i].trailingAnchor)
            trailingAnchors.append(trailingAnchor)
        }
        
        let sectionStackViewConstraints = [
            sectionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sectionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sectionStackView.topAnchor.constraint(equalTo: pokemonTypeStackView.bottomAnchor, constant: 16),
            sectionStackView.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let indicatorConstraints = [
            leadingAnchors[0],
            trailingAnchors[0],
            indicator.topAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[0].bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 4)
        ]
        
        let sectionViewContainerConstraints = [
            sectionViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sectionViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sectionViewContainer.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 20),
            sectionViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        
        NSLayoutConstraint.activate(pokemonImageViewConstraints)
        NSLayoutConstraint.activate(pokemonTypeStackViewConstraints)
        NSLayoutConstraint.activate(sectionStackViewConstraints)
        NSLayoutConstraint.activate(indicatorConstraints)
        NSLayoutConstraint.activate(sectionViewContainerConstraints)
        NSLayoutConstraint.activate(errorStackViewConstraints)
        NSLayoutConstraint.activate(loadingAnimationConstraints)
    }
    
    private func configureStackButton() {
        for (i, button) in sectionStackView.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else { return }
            button.tintColor = i == selectedTab ? .label : .secondaryLabel
            button.addTarget(self, action: #selector(didTapTab(_:)), for: .touchUpInside)
        }
    }
    
    private func configureChip(title: String) -> UIStackView {
        let stackView = UIStackView()
        
        let label = UILabel()
        label.font = .poppinsMedium(size: 12)
        label.text = title.capitalized
        
        let imageview = UIImageView()
        imageview.image = UIImage(named: ViewDataConverter.typeStringToIconName(type: title))
        imageview.contentMode = .scaleAspectFit
        imageview.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageview.clipsToBounds = true
        
        stackView.spacing = 5
        stackView.addArrangedSubview(imageview)
        stackView.addArrangedSubview(label)
        
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.backgroundColor = UIColor(named: ViewDataConverter.typeStringToColorName(type: title))
        stackView.layer.cornerRadius = 15
        
        return stackView
    }
    
    private func setCatchButton() {
        let button = UIBarButtonItem(image: UIImage(named: "icon_pokeball"), style: .plain, target: self, action: #selector(catchAction))
        
        navigationItem.rightBarButtonItem = button
        
    }
    
    @objc private func catchAction() {
        guard let presenter = presenter else { return }
        if(presenter.catchProbState()) {
            showNicknameAlert()
        } else {
            showCommonAlert(title: "title.ooops".localized(), message: "msg.pokemon.missed.run".localized())
        }
    }
    
    private func showCommonAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "title.ok".localized(), style: .default)
        
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    private func showNicknameAlert() {
        let alert = UIAlertController(title: "title.gotcha".localized(), message: "msg.choose.new.nickname".localized(), preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = self.pokemon?.name
        }
        alert.addAction(UIAlertAction(title: "title.ok".localized(), style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.presenter?.putCatchedPokemon(pokemon: self.pokemon!, nickname: textField?.text ?? "")
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapTab(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else { return }
        switch label {
        case SectionTabs.about.rawValue:
            selectedTab = 0
            removeSubViewController(viewController: baseStatSubViewController)
            removeSubViewController(viewController: movesSubViewController)
            addSubViewController(viewController: aboutSubViewController, contentView: sectionViewContainer)
        case SectionTabs.stat.rawValue:
            selectedTab = 1
            removeSubViewController(viewController: aboutSubViewController)
            removeSubViewController(viewController: movesSubViewController)
            addSubViewController(viewController: baseStatSubViewController, contentView: sectionViewContainer)
        case SectionTabs.moves.rawValue:
            selectedTab = 2
            removeSubViewController(viewController: baseStatSubViewController)
            removeSubViewController(viewController: aboutSubViewController)
            addSubViewController(viewController: movesSubViewController, contentView: sectionViewContainer)
        default:
            removeSubViewController(viewController: baseStatSubViewController)
            removeSubViewController(viewController: movesSubViewController)
            addSubViewController(viewController: aboutSubViewController, contentView: sectionViewContainer)
            selectedTab = 0
        }
    }
    
    private func showLoading(isLoading: Bool) {
        UIView.transition(with: loadingAnimation, duration: 0.4) {
            self.loadingAnimation.isHidden = !isLoading
        }
        
        UIView.transition(with: backdropLoading, duration: 0.4) {
            self.backdropLoading.isHidden = !isLoading
        }
    }
    
    private func showError(isError: Bool) {
        UIView.transition(with: errorStackView, duration: 0.4, options: .transitionCrossDissolve) {
            self.errorStackView.isHidden = !isError
        }
        
        UIView.transition(with: sectionStackView, duration: 0.4, options: .transitionCrossDissolve) {
            self.sectionStackView.isHidden = isError
        }
        
        UIView.transition(with: sectionViewContainer, duration: 0.4, options: .transitionCrossDissolve) {
            self.sectionViewContainer.isHidden = isError
        }
        
        UIView.transition(with: pokemonImageView, duration: 0.4, options: .transitionCrossDissolve) {
            self.pokemonImageView.isHidden = isError
        }
        
        UIView.transition(with: pokemonTypeStackView, duration: 0.4, options: .transitionCrossDissolve) {
            self.pokemonTypeStackView.isHidden = isError
        }
        
        UIView.transition(with: sectionStackView, duration: 0.4, options: .transitionCrossDissolve) {
            self.sectionStackView.isHidden = isError
        }
        
        UIView.transition(with: indicator, duration: 0.4, options: .transitionCrossDissolve) {
            self.indicator.isHidden = isError
        }
    }
}
