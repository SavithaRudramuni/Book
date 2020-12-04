//
//  APIUtility.swift
//  Books
//
//  Created by Savitha Rudramuni on 03/12/20.
//

import Foundation


enum APIError:Error {
    case invalidRequest
    case serverError
    
    
}

extension Error {
    
    func converToApiError()->APIError? {
        return APIError.serverError
    }
}

class APIUtility {
    
}
