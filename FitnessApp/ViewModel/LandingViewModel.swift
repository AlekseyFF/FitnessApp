//
//  LandingViewModel.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 18.01.2022.
//

import Foundation
import SwiftUI

final class LandingViewModel: ObservableObject {
    @Published var loginSignupPushed = false
    @Published var createPushed = false
    
    let title = "ЯХААЙ БАЛЯ"
    let createButtonTitle = "Create a challenge"
    let createButtonImageName = "plus.circle"
    let alreadyButtonTitle = "I already have an account"
    let backgroundImageName = "work"
}
