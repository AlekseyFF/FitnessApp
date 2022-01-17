//
//  SettingItemViewModel.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 10.01.2022.
//

import Foundation

extension SettingsViewModel {
    struct SettingsItemViewModel {
        let title: String
        let iconName: String
        let type: SettingItemType
    }
    
    enum SettingItemType {
        case account
        case mode
        case privacy
        case logout
    }
}
