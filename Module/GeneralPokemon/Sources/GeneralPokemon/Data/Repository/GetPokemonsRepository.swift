//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import Foundation
import Core
import RxSwift

public struct GetPokemonsRepository<
    PokemonLocaleDataSource: LocaleDataSource,
    PokemonRemoteDataSource: RemoteDataSource,
    Transformer: Mapper
>: Repository where
PokemonLocaleDataSource.Response == PokemonEntity,
PokemonLocaleDataSource.Request == Int,
PokemonRemoteDataSource.Response == [PokemonItemResponse],
PokemonRemoteDataSource.Request == Int,
Transformer.Response == [PokemonItemResponse],
Transformer.Entity == [PokemonEntity],
Transformer.Domain == [PokemonDomainModel]
{
    public typealias Request = Int
    
    public typealias Response = [PokemonDomainModel]
    
    private var _localeDataSource: PokemonLocaleDataSource
    private var _remoteDataSource: PokemonRemoteDataSource
    private var _mapper: Transformer
    
    public init(
        localeDataSource: PokemonLocaleDataSource,
        remoteDataSource: PokemonRemoteDataSource,
        mapper: Transformer
    ) {
        _localeDataSource = localeDataSource
        _remoteDataSource = remoteDataSource
        _mapper = mapper
    }
    
    public func execute(request: Int?) -> RxSwift.Observable<[PokemonDomainModel]> {
        
        guard let pagination = request else { fatalError() }
        return _localeDataSource.list(request: pagination)
            .map { _mapper.transformEntityToDomain(entity: $0) }
            .filter { !$0.isEmpty }
            .ifEmpty(switchTo: _remoteDataSource.get(request: pagination)
                .map { _mapper.transformResponseToEntity(response: $0) }
                .flatMap {
                    _localeDataSource.inserts(entities:
                                                $0.map{ item in
                        item.offset = pagination
                        return item
                    }
                    )
                }
                .filter { $0 }
                .flatMap { _ in _localeDataSource.list(request: pagination)
                        .map { _mapper.transformEntityToDomain(entity: $0) }
                }
                     
            )
    }
    
}
