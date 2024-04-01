//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import RxSwift

public struct Interactor<Request, Response, R: Repository>: UserCase
where
R.Request == Request,
R.Response == Response {
    private let _repository: R
    
    public init(repository: R) {
        _repository = repository
    }
    
    public func execute(request: Request?) -> Observable<Response> {
        _repository.execute(request: request)
    }
}
