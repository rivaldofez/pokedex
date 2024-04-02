//
//  File.swift
//
//
//  Created by rivaldo on 02/04/24.
//

import Foundation
import RxSwift
import Core

public struct GetCatchPokemonRepository<
    CatchPokemonLocaleDataSource: LocaleDataSource,
    Transformer: Mapper
>: Repository where
CatchPokemonLocaleDataSource.Request == String,
CatchPokemonLocaleDataSource.Response == CatchPokemonEntity,
Transformer.Response == [Any],
Transformer.Entity == [CatchPokemonEntity],
Transformer.Domain == [CatchPokemonDomainModel]
{
    public typealias Request = String
    
    public typealias Response = [CatchPokemonDomainModel]
    
    private var _localeDataSource: CatchPokemonLocaleDataSource
    private var _mapper: Transformer
    
    public init(
        localeDataSource: CatchPokemonLocaleDataSource,
        mapper: Transformer
    ) {
        _localeDataSource = localeDataSource
        _mapper = mapper
    }
    
    public func execute(request: String?) -> RxSwift.Observable<[CatchPokemonDomainModel]> {
        return _localeDataSource.list(request: request)
            .map { _mapper.transformEntityToDomain(entity: $0) }
    }
}
