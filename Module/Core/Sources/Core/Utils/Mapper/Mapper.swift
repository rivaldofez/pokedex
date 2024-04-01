//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import Foundation

public protocol Mapper {
    associatedtype Response
    associatedtype Entity
    associatedtype Domain
    
    func transformResponseToEntity(response: Response) -> Entity
    func transformEntityToDomain(entity: Entity) -> Domain
    func transformResponseToDomain(response: Response) -> Domain
    func transformDomainToEntity(domain: Domain) -> Entity
}
