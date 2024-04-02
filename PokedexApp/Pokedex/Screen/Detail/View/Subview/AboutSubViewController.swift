//
//  AboutSubviewController.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import UIKit
import GeneralPokemon
import SpeciesPokemon
import Common

class AboutSubViewController: UIViewController {
    
    private var aboutDataModel: [AboutCellModel] = []
    
    var pokemonSpecies: PokemonSpeciesDomainModel? {
        didSet {
            guard let pokemonSpecies = pokemonSpecies else { return }
            
            aboutLabel.text = pokemonSpecies.about
            setDataAboutTableView()
        }
    }
    
    var pokemon: PokemonDomainModel? {
        didSet {
            setDataAboutTableView()
        }
    }
    
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .comfortaaLight(size: 14)
        return label
    }()
    
    private let aboutTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(AboutTableViewCell.self, forCellReuseIdentifier: AboutTableViewCell.identifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(aboutLabel)
        view.addSubview(aboutTableView)
        configureConstraints()
        
        aboutTableView.delegate = self
        aboutTableView.dataSource = self
    }
    
    private func setDataAboutTableView() {
        guard let pokemon = pokemon, let pokemonSpecies = pokemonSpecies else { return }
        
        self.aboutDataModel = ViewDataConverter.typePokemonToAboutSection(
            pokemon: pokemon, pokemonSpecies: pokemonSpecies
        )
        
        DispatchQueue.main.async {
            self.aboutTableView.reloadData()
        }
    }
    
    private func configureConstraints() {
        let aboutLabelConstraints = [
            aboutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            aboutLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            aboutLabel.topAnchor.constraint(equalTo: view.topAnchor)
        ]
        
        let aboutTableViewConstraints = [
            aboutTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            aboutTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            aboutTableView.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 8),
            aboutTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ]
        
        NSLayoutConstraint.activate(aboutLabelConstraints)
        NSLayoutConstraint.activate(aboutTableViewConstraints)
    }
    
}

extension AboutSubViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        aboutDataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AboutTableViewCell.identifier,
            for: indexPath
        ) as? AboutTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: aboutDataModel[indexPath.section].item[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return aboutDataModel[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutDataModel[section].item.count
    }
}
