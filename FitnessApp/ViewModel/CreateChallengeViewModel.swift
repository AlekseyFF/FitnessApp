//
//  CreateChallengeViewModel.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 24.12.2021.
//

import SwiftUI
import Combine
import Firebase

typealias UserId = String

final class CreateChallengeViewModel: ObservableObject {

    @Published var exerciseDropdown = ChallengePartViewModel(type: .exercise)
    @Published var startAmountDropdown = ChallengePartViewModel(type: .startAmount)
    @Published var increaseDropdown = ChallengePartViewModel(type: .increase)
    @Published var lengthDropdown = ChallengePartViewModel(type: .length)
    
    private let userService: UserServiceProtocol
    private var cancellables: [AnyCancellable] = []
    
    enum Action {
        case createChallenge
    }
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func send(_ action: Action) {
        switch action {
        case .createChallenge:
            currentUserId().sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("completed")
                }
            } receiveValue: { userId in
                print("retrieved user id = \(userId)")
            }.store(in: &cancellables)
            
        }
    }
    
    private func currentUserId() -> AnyPublisher<UserId, Error> {
        print("getting user id")
        return userService.currentUser().flatMap { user -> AnyPublisher<UserId, Error> in
            if let userId = user?.uid {
                print("user is logged in...")
                
                return Just(userId)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                print("user is being logged in anonymously...")
                
                return self.userService
                    .signInAnonymously()
                    .map { $0.uid }
                    .eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
}


extension CreateChallengeViewModel {
    
    struct ChallengePartViewModel: DropdownItemProtocol {
        var selectedOption: DropdownOption
        
        
        var options: [DropdownOption]
        var headerTitle: String {
            type.rawValue
        }
        var dropdownTitle: String {
            selectedOption.formatted
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
            self.selectedOption = options.first!
            
        }
        
        enum ChallengePartType: String, CaseIterable {
            case exercise = "Exercise"
            case startAmount = "Starting Amount"
            case increase = "Daily Increase"
            case length = "Challenge Length"
        }
        
        enum ExerciceOption: String, CaseIterable, DropdownOptionProtocol {
            
            var toDropdownOption: DropdownOption {
                .init(type: .text(rawValue), formatted: rawValue.capitalized)
            }
            
            case pullups
            case pushups
            case situps
            
        }
        
        enum StartOption: Int, CaseIterable, DropdownOptionProtocol {
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue), formatted: "\(rawValue)")
            }
            
            case one = 1, two, three, four, five
        }
        
        enum IncreaseOption: Int, CaseIterable, DropdownOptionProtocol {
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue), formatted: "+\(rawValue)")
            }
            
            case one = 1, two, three, four, five
        }
        
        enum LengthOption: Int, CaseIterable, DropdownOptionProtocol {
            
            var toDropdownOption: DropdownOption {
                .init(type: .number(rawValue), formatted: "\(rawValue) days")
            }
            
            case seven = 7, fourteen = 14, twentyOne = 21, twentyEight = 28
        }
    }
}
