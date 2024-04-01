//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import RxSwift

public protocol RemoteDataSource {
    associatedtype Request
    associatedtype Response
    
    func get(request: Request?) -> Observable<Response>
}
