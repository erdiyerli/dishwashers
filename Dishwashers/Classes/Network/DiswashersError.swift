//
//  DiswashersErrors.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import Base

struct DiswashersError<T: ErrorType>: Error {
    public let type: T
    public let internalError: Error?

    init(type: T, internalError: Error? = nil) {
        self.type = type
        self.internalError = internalError
    }

    var localizedDescription: String {
        return "\(type.domain) - \(type.description) (\(type.code))"
    }
}

enum DataError: Int, ErrorType {

    var description: String {
        switch self {
        case .parse:
            return ""
        case .invalidJSON:
            return ""
        case .unhandled:
            return ""
        }
    }

    var code: Int {
        return self.rawValue
    }

    case parse = 1300
    case invalidJSON = 1301
    case unhandled = 1302
}
