//
//  CreateChallengeViewModel.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 24.12.2021.
//

import SwiftUI

final class CreateChallengeViewModel: ObservableObject {
    @Published var dropdowns: [ChallengePartViewModel] = [
        .init(type: .exercise),
        .init(type: .startAmount),
        .init(type: .increase),
        .init(type: .length)
    ]
    
    enum Action {
        case selectOption(index: Int)
    }
    
    var hasSelectedDropdown: Bool {
        selectedDropdownIndex != nil
    }
    var selectedDropdownIndex: Int? {
        dropdowns.enumerated().first(where: { $0.element.isSelected })?.offset
    }
    var displayedOptions: [DropdownOption] {
        guard let selectedDropdownIndex = selectedDropdownIndex else { return [] }

        return dropdowns[selectedDropdownIndex].options
    }
    
    func send(_ action: Action) {
        switch action {
        case let .selectOption(index) :
            guard let selectedDropdownIndex = selectedDropdownIndex else { return }
            clearSelectedOptions()
            dropdowns[selectedDropdownIndex].options[index].isSelected = true
            clearSelectedDropdown()
        }
    }
    func clearSelectedOptions() {
        guard let selectedDropdownIndex = selectedDropdownIndex else { return }

        dropdowns[selectedDropdownIndex].options.indices.forEach { index in
            dropdowns[selectedDropdownIndex].options[index].isSelected = false
        }
    }
    func clearSelectedDropdown() {
        guard let selectedDropdownIndex = selectedDropdownIndex else { return }

        dropdowns[selectedDropdownIndex].isSelected = false
        }
    }


extension CreateChallengeViewModel {
    
    struct ChallengePartViewModel: DropdownItemProtocol {
        
        var options: [DropdownOption]
        var headerTitle: String {
            type.rawValue
        }
        var dropdownTitle: String {
            options.first(where: { $0.isSelected })?.formatted ?? ""
        }
        var isSelected: Bool = false
        
        private let type: ChallengePartType
        
        init(type: ChallengePartType) {
            
            switch type {
            case.exercise:
                self.options = ExerciceOption.allCases.map { $0.toDropdownOption}
            case.startAmount:
                self.options = StartOption.allCases.map { $0.toDropdownOption}
            case.increase:
                self.options = IncreaseOption.allCases.map { $0.toDropdownOption}
            case.length:
                self.options = LengthOption.allCases.map { $0.toDropdownOption}
            }
            self.type = type
            
        }
        
        enum ChallengePartType: String, CaseIterable {
            case exercise = "Exercise"
            case startAmount = "Starting Amount"
            case increase = "Daily Increase"
            case length = "Challenge Length"
        }
        
        enum ExerciceOption: String, CaseIterable, DropdownOptionProtocol {
            
            var toDropdownOption: DropdownOption {
                .init(type: .text(rawValue), formatted: rawValue.capitalized, isSelected: self == .pullups)
            }
            
            case pullups
            case pushups
            case situps
            
        }
        
        enum StartOption: Int, CaseIterable, DropdownOptionProtocol {
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue), formatted: "\(rawValue)", isSelected: self == .one)
            }
            
            case one = 1, two, three, four, five
        }
        
        enum IncreaseOption: Int, CaseIterable, DropdownOptionProtocol {
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue), formatted: "+\(rawValue)", isSelected: self == .one)
            }
            
            case one = 1, two, three, four, five
        }
        
        enum LengthOption: Int, CaseIterable, DropdownOptionProtocol {
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue), formatted: "\(rawValue) days", isSelected: self == .seven)
            }
            
            case seven = 7, fourteen = 14, twentyOne = 21, twentyEight = 28
        }
    }
}
