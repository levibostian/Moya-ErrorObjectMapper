//
//  Response+ObjectMapper.swift
//  Pods
//
//  Created by Levi Bostian on 8/28/17.
//
//

import Foundation
import Moya
import Moya_ObjectMapper
import ObjectMapper

/// Successfully mapped JSON response to string message. Use this error type to show to the user.
public enum MappedError: Swift.Error, LocalizedError {
    case mappedError(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .mappedError(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}

/// Error while trying to map the JSON response to string messaage.
public enum MappingError: Swift.Error, LocalizedError {
    case notStatusCodeError
    case notMoyaError
    
    public var errorDescription: String? {
        switch self {
        case .notStatusCodeError:
            return NSLocalizedString("Error is not a Moya status code error. Skipping to map object.", comment: "")
        case .notMoyaError:
            return NSLocalizedString("Error is not a Moya error. Skipping to map object.", comment: "")
        }
    }
}

public extension Swift.Error {
    
    /// Take error, attempt to map it a Mappable object. 
    /// If error is not a MoyaError.statusCode() or the HTTP status code does not equal status code provided, then the function will simply return itself. 
    /// After calling this funciton, you may use error.localizedDescription to get JSON message mapped here, or existing error message.
    public func mapErrorObjectOrReturnSelf<T>(_ type: T.Type, whenStatusCode statusCode: Int? = nil, context: MapContext? = nil) throws -> Swift.Error where T: BaseMappable, T: ErrorMessageProtocol {
        guard let moyaError = self as? MoyaError else {
            return self
        }
        
        switch moyaError {
        case MoyaError.statusCode(let response):
            if let statusCode = statusCode {
                if response.statusCode != statusCode {
                    return self
                }
            }
            
            do {
                let mappedObject = try response.mapObject(type.self, context: context)
                return MappedError.mappedError(message: mappedObject.getErrorMessage())
            } catch {
                throw MoyaError.jsonMapping(response)
            }
        default:
            return self
        }
        
        return self
    }
    
    /// Take error, attempt to map it a Mappable object.
    /// Throws error if mapping failed or response status code != parameter status code (if given).
    public func mapErrorObject<T>(_ type: T.Type, whenStatusCode statusCode: Int? = nil, context: MapContext? = nil) throws -> MappedError where T: BaseMappable, T: ErrorMessageProtocol {
        guard let moyaError = self as? MoyaError else {
            throw MappingError.notStatusCodeError
        }
        
        guard let mappedError: MappedError = try mapErrorObjectOrReturnSelf(type, whenStatusCode: statusCode, context: context) as? MappedError else {
            throw MappingError.notStatusCodeError
        }
        
        return mappedError
    }
    
}

public extension Swift.Error {
    
    /// Take error, attempt to map it a Mappable object.
    /// If error is not a MoyaError.statusCode() or the HTTP status code does not equal status code provided, then the function will simply return itself.
    /// After calling this funciton, you may use error.localizedDescription to get JSON message mapped here, or existing error message.
    public func mapErrorObjectOrReturnSelf<T>(_ type: T.Type, whenStatusCode statusCode: Int? = nil, context: MapContext? = nil) throws -> Swift.Error where T: ImmutableMappable, T: ErrorMessageProtocol {
        guard let moyaError = self as? MoyaError else {
            return self
        }
        
        switch moyaError {
        case MoyaError.statusCode(let response):
            if let statusCode = statusCode {
                if response.statusCode != statusCode {
                    return self
                }
            }
            
            do {
                let mappedObject = try response.mapObject(type.self, context: context)
                return MappedError.mappedError(message: mappedObject.getErrorMessage())
            } catch {
                throw MoyaError.jsonMapping(response)
            }
        default:
            return self
        }
        
        return self
    }
    
    /// Take error, attempt to map it a Mappable object.
    /// Throws error if mapping failed or response status code != parameter status code (if given).
    public func mapErrorObject<T>(_ type: T.Type, whenStatusCode statusCode: Int? = nil, context: MapContext? = nil) throws -> MappedError where T: ImmutableMappable, T: ErrorMessageProtocol {
        guard let moyaError = self as? MoyaError else {
            throw MappingError.notStatusCodeError
        }
        
        guard let mappedError: MappedError = try mapErrorObjectOrReturnSelf(type, whenStatusCode: statusCode, context: context) as? MappedError else {
            throw MappingError.notStatusCodeError
        }
        
        return mappedError
    }
    
}
