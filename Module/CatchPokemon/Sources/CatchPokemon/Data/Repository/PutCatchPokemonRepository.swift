//
//  File.swift
//  
//
//  Created by rivaldo on 02/04/24.
//

import Foundation
import Core
import RxSwift

public struct PutCatchPokemonRepository<
    CatchPokemonLocaleDataSource: LocaleDataSource,
    Transformer: Mapper
>: Repository
where
CatchPokemonLocaleDataSource.Response == Transformer.Entity,
Transformer.Entity == CatchPokemonEntity,
Transformer.Domain == CatchPokemonDomainModel {
    public typealias Request = Transformer.Domain?
    
    public typealias Response = Bool
    
    private var _localeDataSource: CatchPokemonLocaleDataSource
    private var _mapper: Transformer
    
    public init(
        localeDataSource: CatchPokemonLocaleDataSource,
        mapper: Transformer
    ) {
        _localeDataSource = localeDataSource
        _mapper = mapper
    }
    
    public func execute(request: Transformer.Domain??) -> Observable<Bool> {
        if let request = request {
            return _localeDataSource.insert(entity: _mapper.transformDomainToEntity(domain: request!))
        } else {
            return .just(false)
        }
    }
}
