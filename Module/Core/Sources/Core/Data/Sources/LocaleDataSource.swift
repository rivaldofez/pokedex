//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import RxSwift

public protocol LocaleDataSource {
    associatedtype Request
    associatedtype Response
    
    func list(request: Request?) -> Observable<[Response]>
    func get(id: Int) -> Observable<Response?>
    func inserts(entities: [Response]) -> Observable<Bool>
    func insert(entity: Response) -> Observable<Bool>
    func update(entity: Response) -> Observable<Bool>
}
