//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import Foundation
import RxSwift
import Core

public struct GetPokemonRepository<
    PokemonLocaleDataSource: LocaleDataSource,
    Transformer: Mapper
>: Repository
where
PokemonLocaleDataSource.Response == Transformer.Entity,
Transformer.Entity == PokemonEntity,
Transformer.Domain == PokemonDomainModel {
    public typealias Request = Int
    
    public typealias Response = Transformer.Domain
    
    private var _localeDataSource: PokemonLocaleDataSource
    private var _mapper: Transformer
    
    public init(
        localeDataSource: PokemonLocaleDataSource,
        mapper: Transformer
    ) {
        _localeDataSource = localeDataSource
        _mapper = mapper
    }
    
    public func execute(request: Int?) -> Observable<Transformer.Domain> {
        guard let request = request else { fatalError() }
        
        return _localeDataSource.get(id: request)
            .map{ _mapper.transformEntityToDomain(entity: $0!) }
    }
}
