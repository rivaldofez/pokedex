//
//  File.swift
//  
//
//  Created by rivaldo on 02/04/24.
//

import Foundation
import Core
import RealmSwift
import RxSwift

public struct CatchPokemonLocaleDataSource: LocaleDataSource {
    
    public typealias Request = String
    
    public typealias Response = CatchPokemonEntity
    
    private let _realm: Realm
    
    public init(realm: Realm) {
        _realm = realm
    }
    
    public func list(request: String?) -> Observable<[CatchPokemonEntity]>{
        return Observable<[CatchPokemonEntity]>.create { observer in
            let pokeData: Results<CatchPokemonEntity> = {
                _realm.objects(CatchPokemonEntity.self)
                    .sorted(byKeyPath: "catchDate", ascending: false)
            }()
            if let request = request {
                if request.isEmpty {
                    observer.onNext(pokeData.toArray(ofType: CatchPokemonEntity.self))
                } else {
                    let filteredData = pokeData.where { $0.name.contains(request, options: .caseInsensitive )}
                    
                    observer.onNext(filteredData.toArray(ofType: CatchPokemonEntity.self))
                }
            } else {
                observer.onNext(pokeData.toArray(ofType: CatchPokemonEntity.self))
            }
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    public func inserts(entities: [CatchPokemonEntity]) -> Observable<Bool> {
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
    
    public func insert(entity: CatchPokemonEntity) -> Observable<Bool> {
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
    
    public func get(id: Int) -> RxSwift.Observable<CatchPokemonEntity?> {
        return Observable<CatchPokemonEntity?>.create { observer in
            let pokeList: Results<CatchPokemonEntity> = {
                _realm.objects(CatchPokemonEntity.self)
                    .where { $0.id == id }
            }()
            
            observer.onNext(pokeList.toArray(ofType: CatchPokemonEntity.self).first)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    public func update(entity: CatchPokemonEntity) -> Observable<Bool> {
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
    
    public func delete(entity: CatchPokemonEntity) -> Observable<Bool> {
        let id = entity.catchId
        
        let pokeRes = _realm.object(ofType: CatchPokemonEntity.self,
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
