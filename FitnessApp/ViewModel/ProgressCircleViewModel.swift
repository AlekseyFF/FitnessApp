//
//  ProgressCircleViewModel.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 10.01.2022.
//

import Foundation
import SwiftUI

struct ProgressCircleViewModel {
    let title : String
    let message: String
    let percentageComplete: Double
    var shouldShowTitle: Bool {
        percentageComplete <= 1
    }
}
