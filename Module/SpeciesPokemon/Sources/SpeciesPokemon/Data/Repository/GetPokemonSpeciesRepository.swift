//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import Foundation
import Core
import RxSwift

public struct GetPokemonSpeciesRepository<
    PokemonSpeciesLocaleDataSource: LocaleDataSource,
    PokemonSpeciesRemoteDataSource: RemoteDataSource,
    Transformer: Mapper
>: Repository where
PokemonSpeciesLocaleDataSource.Response == PokemonSpeciesEntity,
PokemonSpeciesRemoteDataSource.Response == PokemonSpeciesResponse,
PokemonSpeciesRemoteDataSource.Request == Int,
Transformer.Response == PokemonSpeciesResponse?,
Transformer.Entity == PokemonSpeciesEntity?,
Transformer.Domain == PokemonSpeciesDomainModel?
{
    public typealias Request = Int
    
    public typealias Response = PokemonSpeciesDomainModel?
    
    
    private var _localeDataSource: PokemonSpeciesLocaleDataSource
    private var _remoteDataSource: PokemonSpeciesRemoteDataSource
    private var _mapper: Transformer
    
    public init(
        localeDataSource: PokemonSpeciesLocaleDataSource,
        remoteDataSource: PokemonSpeciesRemoteDataSource,
        mapper: Transformer
    ) {
        _localeDataSource = localeDataSource
        _remoteDataSource = remoteDataSource
        _mapper = mapper
    }
    
    public func execute(request: Int?) -> RxSwift.Observable<PokemonSpeciesDomainModel?> {
        
        guard let id = request else { fatalError() }
        return _localeDataSource.get(id: id)
            .map { _mapper.transformEntityToDomain(entity: $0) }
            .filter{ $0 != nil }
            .ifEmpty(switchTo: _remoteDataSource.get(request: id)
                .map { _mapper.transformResponseToEntity(response: $0)! }
                .flatMap { _localeDataSource.insert(entity: $0) }
                .filter { $0 }
                .flatMap { _ in _localeDataSource.get(id: id)
                        .map { _mapper.transformEntityToDomain(entity: $0) }
                }
            )
    }
}
