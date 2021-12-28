//
//  IncrementError.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 28.12.2021.
//

import Foundation

enum IncrementError: LocalizedError {
    
    case auth(description: String)
    case `default`(desctiption: String? = nil)
    
    var errorDescription: String? {
        switch self {
        case let .auth(description):
            return description
        case let .default(description):
            return description ?? "Something went wrong"
        }
    }
}
