//
//  CatchedPokemonTableViewCell.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import UIKit
import CatchPokemon

class CatchedPokemonTableViewCell: UITableViewCell {
    static let identifier = String(describing: CatchedPokemonTableViewCell.self)
    
    // MARK: View Components
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 1
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let pokemonTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 1
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let pokeballImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "pokeball")
        imageView.alpha = 0.3
        return imageView
    }()
    
    private let pokemonNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .poppinsRegular(size: 16)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .poppinsMedium(size: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var pokemonTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(pokemonTypeStackView)
        contentView.addSubview(pokeballImageView)
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(pokemonTypeImageView)
        contentView.addSubview(pokemonNameLabel)
        contentView.addSubview(pokemonNicknameLabel)
        
        configureConstraints()
    }
    
    // Reset Cell For Reuse
    override func prepareForReuse() {
        for view in pokemonTypeStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    // MARK: Auto Layout Constraints
    private func configureConstraints() {
        let pokemonImageViewConstraints = [
            pokemonImageView.leadingAnchor.constraint(equalTo: pokeballImageView.leadingAnchor, constant: 16),
            pokemonImageView.trailingAnchor.constraint(equalTo: pokeballImageView.trailingAnchor, constant: -16),
            pokemonImageView.bottomAnchor.constraint(equalTo: pokeballImageView.bottomAnchor, constant: -16),
            pokemonImageView.topAnchor.constraint(equalTo: pokeballImageView.topAnchor, constant: 16)
        ]
        
        let pokeballImageViewConstraints = [
            pokeballImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            pokeballImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            pokeballImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            pokeballImageView.widthAnchor.constraint(equalToConstant: 90),
            pokeballImageView.heightAnchor.constraint(equalToConstant: 90)
            
        ]
        
        let pokemonNumberLabelConstraints = [
            pokemonNicknameLabel.leadingAnchor.constraint(equalTo: pokeballImageView.trailingAnchor, constant: 8),
            pokemonNicknameLabel.topAnchor.constraint(equalTo: pokeballImageView.topAnchor)
        ]
        
        let pokemonNameLabelConstraints = [
            pokemonNameLabel.leadingAnchor.constraint(equalTo: pokeballImageView.trailingAnchor, constant: 8),
            pokemonNameLabel.topAnchor.constraint(equalTo: pokemonNicknameLabel.bottomAnchor, constant: 4)
        ]
        
        let pokemonTypeStackViewConstraints = [
            pokemonTypeStackView.leadingAnchor.constraint(equalTo: pokeballImageView.trailingAnchor, constant: 8),
            pokemonTypeStackView.topAnchor.constraint(equalTo: pokemonNameLabel.bottomAnchor, constant: 4)
        ]
        
        NSLayoutConstraint.activate(pokemonImageViewConstraints)
        NSLayoutConstraint.activate(pokeballImageViewConstraints)
        NSLayoutConstraint.activate(pokemonNumberLabelConstraints)
        NSLayoutConstraint.activate(pokemonNameLabelConstraints)
        NSLayoutConstraint.activate(pokemonTypeStackViewConstraints)
    }
    
    // MARK: Cell Data Bind
    func configure(with model: CatchPokemonDomainModel) {
        pokemonNicknameLabel.text = model.nickname
        pokemonNameLabel.text = model.name.capitalized
        
        guard let imageUrl = URL(string: model.image) else { return }
        pokemonImageView.sd_setImage(with: imageUrl)
        
        model.type.forEach { title in
            pokemonTypeStackView.addArrangedSubview(configureChip(title: title))
        }
        
        guard let typeElement = model.type.first else { return }
        
        contentView.layer.borderColor = UIColor(named: ViewDataConverter.typeStringToColorName(type: typeElement))?.cgColor
    }
    
    // Chip Configuration
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
