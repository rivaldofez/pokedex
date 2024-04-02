//
//  MovesTableViewCell.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import UIKit

class MovesTableViewCell: UITableViewCell {
    
    static let identifier = "MovesTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Razor Leaf"
        label.font = .comfortaaRegular(size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        
        configureConstraints()
    }
    
    func configure(with move: String) {
        titleLabel.text = move.capitalized
    }
    
    private func configureConstraints() {
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

