//
//  ViewDataConverter.swift
//  pokedex
//
//  Created by rivaldo on 02/04/24.
//

import Foundation
import GeneralPokemon
import SpeciesPokemon

final class ViewDataConverter {
    
    enum PokemonElement: String {
        case bug
        case dark
        case dragon
        case electric
        case fairy
        case fighting
        case fire
        case flying
        case ghost
        case grass
        case ground
        case ice
        case normal
        case poison
        case psychic
        case rock
        case steel
        case water
    }
    
    enum PokemonStat: String {
        case hp = "hp"
        case attack = "attack"
        case defense = "defense"
        case spAttack = "special-attack"
        case spDefense = "special-defense"
        case speed = "speed"
    }
    
    static func typeStringToIconName(type: String) -> String {
        guard let pokemonElement = PokemonElement(rawValue: type) else { return "unknown"}
        switch pokemonElement {
        case .bug:
            return "icon_bug"
        case .dark:
            return "icon_dark"
        case .dragon:
            return "icon_dragon"
        case .electric:
            return "icon_electric"
        case .fairy:
            return "icon_fairy"
        case .fighting:
            return "icon_fighting"
        case .fire:
            return "icon_fire"
        case .flying:
            return "icon_flying"
        case .ghost:
            return "icon_ghost"
        case .grass:
            return "icon_grass"
        case .ground:
            return "icon_ground"
        case .ice:
            return "icon_ice"
        case .normal:
            return "icon_normal"
        case .poison:
            return "icon_poison"
        case .psychic:
            return "icon_psychic"
        case .rock:
            return "icon_rock"
        case .steel:
            return "icon_steel"
        case .water:
            return "icon_water"
        }
    }
    
    static func typeStringToColorName(type: String) -> String {
        guard let pokemonElement = PokemonElement(rawValue: type) else { return "unknown"}
        switch pokemonElement {
        case .bug:
            return "color_bug"
        case .dark:
            return "color_dark"
        case .dragon:
            return "color_dragon"
        case .electric:
            return "color_electric"
        case .fairy:
            return "color_fairy"
        case .fighting:
            return "color_fighting"
        case .fire:
            return "color_fire"
        case .flying:
            return "color_flying"
        case .ghost:
            return "color_ghost"
        case .grass:
            return "color_grass"
        case .ground:
            return "color_ground"
        case .ice:
            return "color_ice"
        case .normal:
            return "color_normal"
        case .poison:
            return "color_poison"
        case .psychic:
            return "color_psychic"
        case .rock:
            return "color_rock"
        case .steel:
            return "color_steel"
        case .water:
            return "color_water"
        }
    }
    
    static func typeStringToStatName(type: String) -> String {
        guard let pokemonStat = PokemonStat(rawValue: type) else { return "unknown"}
        
        switch pokemonStat {
        case .hp:
            return "Hp"
        case .attack:
            return "Atk"
        case .defense:
            return "Def"
        case .spAttack:
            return "Sp.Atk"
        case .spDefense:
            return "Sp.Def"
        case .speed:
            return "Speed"
        }
    }
    
    static func typePokemonToAboutSection(pokemon: PokemonDomainModel, pokemonSpecies: PokemonSpeciesDomainModel) -> [AboutCellModel] {
            var dataAboutCellModel: [AboutCellModel] = []
            
            var speciesItemCellModel: [ItemCellModel] = []
            speciesItemCellModel.append(ItemCellModel(title: "Genus", value: pokemonSpecies.genus))
            speciesItemCellModel.append(ItemCellModel(title: "Height", value: "\(pokemon.height) m"))
            speciesItemCellModel.append(ItemCellModel(title: "Weight", value: "\(pokemon.weight) kg"))
            speciesItemCellModel.append(ItemCellModel(title: "Abilities", value: pokemon.abilities))
            speciesItemCellModel.append(ItemCellModel(title: "Status", value: pokemonSpecies.isLegendary ? "Legendary" : pokemonSpecies.isMythical ? "Mythical" : "Common"))
            speciesItemCellModel.append(ItemCellModel(title: "Habitat", value: pokemonSpecies.habitat))
            let speciesCellModel = AboutCellModel(name: "Species", item: speciesItemCellModel)
            
            var physicalItemCellModel: [ItemCellModel] = []
            physicalItemCellModel.append(ItemCellModel(title: "Growth Rate", value: pokemonSpecies.growthRate))
            physicalItemCellModel.append(ItemCellModel(title: "Hatch Counter", value: String(pokemonSpecies.hatchCounter)))
            physicalItemCellModel.append(ItemCellModel(title: "Base Happines", value: String(pokemonSpecies.baseHappines)))
            physicalItemCellModel.append(ItemCellModel(title: "Base Experience", value: String(pokemon.baseExp)))
            physicalItemCellModel.append(ItemCellModel(title: "Capture Rate", value: String(pokemonSpecies.captureRate)))
            let physicalCellModel = AboutCellModel(name: "Physical", item: physicalItemCellModel)
            
            var breedingItemCellModel: [ItemCellModel] = []
            breedingItemCellModel.append(ItemCellModel(title: "Gender", value: pokemonSpecies.genderRate))
            breedingItemCellModel.append(ItemCellModel(title: "Egg Groups", value: pokemonSpecies.eggGroups))
            breedingItemCellModel.append(ItemCellModel(title: "Baby Pokemon", value: pokemonSpecies.isBaby ? "Yes" : "No"))
            let breedingCellModel = AboutCellModel(name: "Breeding", item: breedingItemCellModel)
            
            dataAboutCellModel.append(speciesCellModel)
            dataAboutCellModel.append(physicalCellModel)
            dataAboutCellModel.append(breedingCellModel)
            
            return dataAboutCellModel
        }
}
