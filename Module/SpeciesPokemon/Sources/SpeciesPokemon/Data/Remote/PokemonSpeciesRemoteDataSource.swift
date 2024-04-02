//
//  File.swift
//  
//
//  Created by rivaldo on 02/04/24.
//

import Foundation
import Core
import Alamofire
import RxSwift

public struct PokemonSpeciesRemoteDataSource: RemoteDataSource {

    public typealias Request = Int
    
    public typealias Response = PokemonSpeciesResponse
    
    private let endpoint: (Int) -> (String)
    
    public init(endpoint: @escaping (Int) -> String) {
        self.endpoint = endpoint
    }
    
    public func get(request: Int?) -> RxSwift.Observable<PokemonSpeciesResponse> {
        return Observable<PokemonSpeciesResponse>.create { observer in
            if let request = request {
                if let url = URL(string: self.endpoint(request)) {
                    AF.request(url)
                        .responseDecodable(of: PokemonSpeciesResponse.self) { response in
                            switch response.result {
                            case .success(let value):
                                observer.onNext(value)
                                observer.onCompleted()
                            case .failure:
                                observer.onError(URLError.invalidResponse)
                            }
                        }
                    
                } else {
                    //invalid url
                }
                
            } else {
                //error id
            }
            
            return Disposables.create()
        }
        
    }

}

