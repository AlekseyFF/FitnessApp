//
//  Challenge.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 28.12.2021.
//

import Foundation
import FirebaseFirestoreSwift

struct Challenge: Codable {
    @DocumentID var id: String?
    let exercise: String
    let startAmount: Int
    let increase: Int
    let length: Int
    let userId: String
    let startDate: Date
    let activities: [Activity]
}

struct Activity: Codable{
    let date: Date
    let isComplete:Bool
    
}
