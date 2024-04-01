//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import RxSwift
import RealmSwift
import Foundation
import Core

public struct PokemonSpeciesLocaleDataSource: LocaleDataSource {
    public func inserts(entities: [PokemonSpeciesEntity]) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            do {
                try _realm.write {
                    for entity in entities {
                        _realm.add(entity, update: .all)
                    }
                }
                observer.onNext(true)
                observer.onCompleted()
            } catch {
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    public typealias Request = Any
    
    public typealias Response = PokemonSpeciesEntity
    
    private let _realm: Realm
    
    public init(realm: Realm) {
        _realm = realm
    }
    
    
    public func list(request: Request?) -> Observable<[PokemonSpeciesEntity]> {
        return Observable<[PokemonSpeciesEntity]>.create { observer in
            let pokeSpecies: Results<PokemonSpeciesEntity> = {
                _realm.objects(PokemonSpeciesEntity.self)
                    .sorted(byKeyPath: "id", ascending: true)
            }()
            observer.onNext(pokeSpecies.toArray(ofType: PokemonSpeciesEntity.self))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    public func insert(entity: PokemonSpeciesEntity) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            do {
                try _realm.write {
                    _realm.add(entity, update: .all)
                }
                observer.onNext(true)
                observer.onCompleted()
            } catch {
                observer.onError(DatabaseError.invalidInstance)
            }
            
            return Disposables.create()
        }
    }
    
    public func get(id: Int) -> Observable<PokemonSpeciesEntity?> {
        return Observable<PokemonSpeciesEntity?>.create { observer in
            let pokeSpeciesList: Results<PokemonSpeciesEntity> = {
                _realm.objects(PokemonSpeciesEntity.self)
                    .where { $0.id == id }
            }()
            
            observer.onNext(pokeSpeciesList.toArray(ofType: PokemonSpeciesEntity.self).first)
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    public func update(entity: PokemonSpeciesEntity) -> RxSwift.Observable<Bool> {
        return Observable<Bool>.create { observer in
            do {
                try _realm.write {
                    _realm.add(entity, update: .modified)
                }
                observer.onNext(true)
                observer.onCompleted()
            } catch {
                observer.onError(DatabaseError.invalidInstance)
            }
            
            return Disposables.create()
        }
    }
}

