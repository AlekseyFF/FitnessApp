//
//  ChallengeListView.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 29.12.2021.
//

import SwiftUI

struct ChallengeListView: View {
    @StateObject private var vieModel = ChallengeListViewModel()
    var body: some View {
        Text("Challenge List")
    }
}
