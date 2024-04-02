//
//  MovesSubviewController.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import UIKit
import GeneralPokemon

class MovesSubViewController: UIViewController {
    
    var pokemon: PokemonDomainModel? {
        didSet {
            DispatchQueue.main.async {
                self.movesTableView.reloadData()
            }
        }
    }
    
    private let movesTableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(MovesTableViewCell.self, forCellReuseIdentifier: MovesTableViewCell.identifier)
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(movesTableView)
        movesTableView.delegate = self
        movesTableView.dataSource = self
        configureConstraints()
    }
    
    private func configureConstraints() {
        let movesTableViewConstraints = [
            movesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            movesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(movesTableViewConstraints)
    }
}

extension MovesSubViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon?.moves.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovesTableViewCell.identifier, for: indexPath) as? MovesTableViewCell else { return UITableViewCell()}
        
        if let moves = pokemon?.moves[indexPath.row] {
            cell.configure(with: moves)
        }
        
        return cell
    }
}
