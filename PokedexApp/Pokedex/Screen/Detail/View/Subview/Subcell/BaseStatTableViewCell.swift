//
//  BaseStatTableViewCell.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import UIKit
import GeneralPokemon

class BaseStatTableViewCell: UITableViewCell {
    static let identifier = "BaseStatTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .poppinsBold(size: 14)
        return label
    }()
    
    private let statLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .comfortaaBold(size: 14)
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progressview = UIProgressView()
        progressview.translatesAutoresizingMaskIntoConstraints = false
        return progressview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(statLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(progressView)
        
        configureConstraints()
        
        progressView.trackTintColor = .lightGray.withAlphaComponent(0.5)
    }
    
    func configure(with baseStat: BaseStat, type: String) {
        titleLabel.text = ViewDataConverter.typeStringToStatName(type: baseStat.name)
        statLabel.text = String(baseStat.value)
        progressView.setProgress(Float(baseStat.value) / 255.0, animated: false)
        
        progressView.tintColor = UIColor(named: ViewDataConverter.typeStringToColorName(type: type))
        
    }
    
    private func configureConstraints() {
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.widthAnchor.constraint(equalToConstant: 50),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]
        
        let statLabelConstraints = [
            statLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            statLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            statLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            statLabel.widthAnchor.constraint(equalToConstant: 30)
        ]
        
        let progressViewConstraints = [
            progressView.leadingAnchor.constraint(equalTo: statLabel.trailingAnchor, constant: 16),
            progressView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 5)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(statLabelConstraints)
        NSLayoutConstraint.activate(progressViewConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
