//
//  PokemonCollectionViewCell.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import UIKit
import SDWebImage
import GeneralPokemon
import Common

class PokemonCollectionViewCell: UICollectionViewCell {
    static let identifier = "PokemonCollectionViewCell"
    
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
    
    private let pokemonNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "999"
        label.font = .poppinsRegular(size: 18)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .poppinsMedium(size: 16)
        label.textColor = .label
        return label
    }()
    
    private let containerImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        
        contentView.addSubview(pokemonNumberLabel)
        contentView.addSubview(pokemonNameLabel)
        contentView.addSubview(pokemonTypeImageView)
        contentView.addSubview(containerImage)
        
        containerImage.addSubview(pokeballImageView)
        containerImage.addSubview(pokemonImageView)
        
        configureConstraints()
    }
    
    // MARK: Auto Layout Constraints
    private func configureConstraints() {
        
        let pokemonImageViewConstraints = [
            pokemonImageView.leadingAnchor.constraint(equalTo: containerImage.leadingAnchor, constant: 10),
            pokemonImageView.trailingAnchor.constraint(equalTo: containerImage.trailingAnchor, constant: -10),
            pokemonImageView.topAnchor.constraint(equalTo: containerImage.topAnchor, constant: 10),
            pokemonImageView.bottomAnchor.constraint(equalTo: containerImage.bottomAnchor, constant: -10)
        ]
        
        let pokeballImageViewConstraints = [
            pokeballImageView.leadingAnchor.constraint(equalTo: containerImage.leadingAnchor),
            pokeballImageView.trailingAnchor.constraint(equalTo: containerImage.trailingAnchor),
            pokeballImageView.topAnchor.constraint(equalTo: containerImage.topAnchor),
            pokeballImageView.bottomAnchor.constraint(equalTo: containerImage.bottomAnchor)
        ]
        
        let containerImageConstraints = [
            containerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerImage.bottomAnchor.constraint(equalTo: pokemonNumberLabel.topAnchor)
        ]
        
        let pokemonNumberLabelConstraints = [
            pokemonNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            pokemonNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            pokemonNumberLabel.bottomAnchor.constraint(equalTo: pokemonNameLabel.topAnchor, constant: -4),
            pokemonNumberLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let pokemonNameLabelConstraints = [
            pokemonNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            pokemonNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            pokemonNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            pokemonNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let pokemonTypeImageViewConstraints = [
            pokemonTypeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            pokemonTypeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            pokemonTypeImageView.widthAnchor.constraint(equalToConstant: 30),
            pokemonTypeImageView.heightAnchor.constraint(equalToConstant: 30)
            
        ]
        NSLayoutConstraint.activate(pokemonNameLabelConstraints)
        NSLayoutConstraint.activate(pokemonNumberLabelConstraints)
        NSLayoutConstraint.activate(pokeballImageViewConstraints)
        NSLayoutConstraint.activate(pokemonImageViewConstraints)
        NSLayoutConstraint.activate(pokemonTypeImageViewConstraints)
        NSLayoutConstraint.activate(containerImageConstraints)
    }
    
    // MARK: Cell Data Bind
    func configure(with model: PokemonDomainModel) {
        pokemonNumberLabel.text = "No.\(model.id)"
        pokemonNameLabel.text = model.name.capitalized
        
        guard let imageUrl = URL(string: model.image) else { return }
        pokemonImageView.sd_setImage(with: imageUrl)
        
        guard let typeElement = model.type.first else { return }
        pokemonTypeImageView.image = UIImage(named: ViewDataConverter.typeStringToIconName(type: typeElement))
        
        contentView.layer.borderColor = UIColor(named: ViewDataConverter.typeStringToColorName(type: typeElement))?.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

