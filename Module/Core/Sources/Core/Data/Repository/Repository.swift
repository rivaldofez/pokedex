//
//  Repository.swift
//
//
//  Created by Rivaldo on 01/04/24.
//

import RxSwift

public protocol Repository {
    associatedtype Request
    associatedtype Response
    
    func execute(request: Request?) -> Observable<Response>
}
