//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import Foundation
import Core
import RealmSwift
import RxSwift

public struct PokemonLocaleDataSource: LocaleDataSource {
    public typealias Request = Int
    
    public typealias Response = PokemonEntity
    
    private let _realm: Realm
    
    public init(realm: Realm) {
        _realm = realm
    }
    
    public func list(request: Int?) -> Observable<[PokemonEntity]> {
        return Observable<[PokemonEntity]>.create { observer in
            let pokeData: Results<PokemonEntity> = {
                _realm.objects(PokemonEntity.self)
                    .where { $0.offset == request ?? 0 }
                    .sorted(byKeyPath: "id", ascending: true)
            }()
            observer.onNext(pokeData.toArray(ofType: PokemonEntity.self))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    public func inserts(entities: [PokemonEntity]) -> Observable<Bool> {
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
    
    public func insert(entity: PokemonEntity) -> Observable<Bool> {
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
    
    
    public func get(id: Int) -> Observable<PokemonEntity?> {
        return Observable<PokemonEntity?>.create { observer in
            let pokeList: Results<PokemonEntity> = {
                _realm.objects(PokemonEntity.self)
                    .where { $0.id == id }
            }()
            
            observer.onNext(pokeList.toArray(ofType: PokemonEntity.self).first)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    public func update(entity: PokemonEntity) -> Observable<Bool> {
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
    
    public func delete(entity: PokemonEntity) -> RxSwift.Observable<Bool> {
        let id = entity.id
        let pokeRes = _realm.object(ofType: PokemonEntity.self,
                                   forPrimaryKey: id)
        
        return Observable<Bool>.create { observer in
            if let pokeRes = pokeRes {
                do {
                    try _realm.write {
                        _realm.delete(pokeRes)
                    }
                    observer.onNext(true)
                    observer.onCompleted()
                } catch {
                    observer.onError(DatabaseError.invalidInstance)
                }
            } else {
                observer.onNext(false)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
