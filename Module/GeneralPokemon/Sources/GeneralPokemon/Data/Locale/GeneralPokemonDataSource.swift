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
    
    
}
