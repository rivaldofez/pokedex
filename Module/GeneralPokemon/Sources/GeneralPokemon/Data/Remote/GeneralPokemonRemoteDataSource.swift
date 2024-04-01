//
//  File.swift
//
//
//  Created by rivaldo on 01/04/24.
//

import Foundation
import Core
import Alamofire
import RxSwift


public struct GeneralPokemonRemoteDataSource: RemoteDataSource {
    private let disposeBag = DisposeBag()
    
    public typealias Request = Int
    public typealias Response = [PokemonItemResponse]
    
    private let endpoint: (Int) -> (String)
    
    public init(endpoint: @escaping (Int) -> String) {
        self.endpoint = endpoint
    }
    
    private func getPokemonItemResponse(urlString: String) -> Observable<PokemonItemResponse> {
        return Observable<PokemonItemResponse>.create { observer in
            if let url = URL(string: urlString) {
                AF.request(url)
                    .responseDecodable(of: PokemonItemResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            observer.onNext(value)
                            observer.onCompleted()
                        case .failure:
                            observer.onError(URLError.invalidResponse)
                        }
                    }
            }
            return Disposables.create()
        }
    }
    
    public func get(request: Int?) -> Observable<[PokemonItemResponse]> {
        
        return Observable<[PokemonItemResponse]>.create { observer in
            if let request = request {
                if let url = URL(string: self.endpoint(request)) {
                    AF.request(url)
                        .responseDecodable(of: PokemonPageResponse.self) { response in
                            switch(response.result) {
                            case .success(let value):
                                var itemResponseObservables: [Observable<PokemonItemResponse>] = []
                                
                                for item in value.pokemonItem {
                                    itemResponseObservables.append(self.getPokemonItemResponse(urlString: item.url))
                                }
                                
                                Observable.zip(itemResponseObservables)
                                    .subscribe { itemResponses in
                                        observer.onNext(itemResponses)
                                    } onError: { error in
                                        observer.onError(error)
                                    } onCompleted: {
                                        observer.onCompleted()
                                    }.disposed(by: self.disposeBag)
                                
                            case.failure:
                                observer.onError(URLError.invalidResponse)
                            }
                        }
                }
            }
            return Disposables.create()
        }
    }
    
}
