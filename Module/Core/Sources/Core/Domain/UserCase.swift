//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import RxSwift

public protocol UseCase {
    associatedtype Request
    associatedtype Response
    
    func execute(request: Request?) -> Observable<Response>
}
