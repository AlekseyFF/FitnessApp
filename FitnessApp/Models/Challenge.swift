//
//  Challenge.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 28.12.2021.
//

import Foundation

struct Challenge: Codable {
    
    let exercise: String
    let startAmount: Int
    let increase: Int
    let length: Int
    let userId: String
    let startDate: Date
}
