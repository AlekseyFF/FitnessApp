//
//  TabContainerView.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 29.12.2021.
//

import SwiftUI

struct TabContainerView: View {
    @StateObject private var tabContainerViewModel = TabContainerViewModel()
    var body: some View {
        TabView(selection: $tabContainerViewModel.selectedTab) {
            ForEach(tabContainerViewModel.tabItemViewModels, id: \.self) { viewModel in
                tabView(for: viewModel.type)
                    .tabItem {
                        Image(systemName: viewModel.imageName)
                        Text(viewModel.title)
                    }.tag(viewModel.type)
            }
        }.accentColor(.purple)
    }
    @ViewBuilder
    func tabView(for tabItemType: TabItemViewModel.TabItemType) -> some View {
        switch tabItemType {
        case .log:
            Text("Log")
        case .challengeList:
            NavigationView {
                ChallengeListView()
            }
        case .settings:
            Text("Settings")
        }
    }
}

final class TabContainerViewModel: ObservableObject {
    @Published var selectedTab: TabItemViewModel.TabItemType = .challengeList
    
    let tabItemViewModels = [TabItemViewModel(imageName: "book", title: "Activity log", type: .log),
                             .init(imageName: "list.bullet", title: "Challenges", type: .challengeList),
                             .init(imageName: "gear", title: "Settings", type: .settings)]
}

struct TabItemViewModel: Hashable {
    let imageName: String
    let title: String
    let type: TabItemType
    
    enum TabItemType {
        case log
        case challengeList
        case settings
    }
}