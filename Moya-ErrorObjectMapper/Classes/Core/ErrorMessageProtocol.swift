//
//  ErrorMessageProtocol.swift
//  Pods
//
//  Created by Levi Bostian on 8/28/17.
//
//

import Foundation

/// Protocol to implement along with BaseMappable or ImmutableMappable. This exists so that we can turn the mapped object into a single string that can be returned to the user.
public protocol ErrorMessageProtocol {
    
    /// Return a human readable message to the user to potentially be shown to them in the app. 
    func getErrorMessage() -> String
    
}
