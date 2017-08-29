//
//  Observable+ObjectMapper.swift
//  Pods
//
//  Created by Levi Bostian on 8/28/17.
//
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

/// Extension for processing Responses into Mappable objects through ObjectMapper when a Moya status code error is thrown.
public extension ObservableType where E == Response {
    
    /// Call this after some Moya `.filter()` status code function(s) that define what is successful and unsuccessful status codes. 
    /// Function does *not* return any value. It will throw the mapped object or original error you can then call error.localizedDescription to get the error message your `type` parameter created.
    public func mapErrorObject<T>(_ type: T.Type, whenStatusCode statusCode: Int? = nil, context: MapContext? = nil) -> Observable<Response> where T: BaseMappable, T: ErrorMessageProtocol {
        return catchError({ (error: Swift.Error) -> Observable<Response> in
            guard let mappedError: MappedError = try error.mapErrorObjectOrReturnSelf(type, whenStatusCode: statusCode, context: context) as? MappedError else {
                throw error
            }
  
            throw mappedError
        })
    }
    
    public func mapErrorObject<T>(_ type: T.Type, whenStatusCode statusCode: Int? = nil, context: MapContext? = nil) -> Observable<Response> where T: ImmutableMappable, T: ErrorMessageProtocol {
        return catchError({ (error: Swift.Error) -> Observable<Response> in
            guard let mappedError: MappedError = try error.mapErrorObjectOrReturnSelf(type, whenStatusCode: statusCode, context: context) as? MappedError else {
                throw error
            }
            
            throw mappedError
        })
    }
    
}
