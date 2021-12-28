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
    
    @Published var error: IncrementError?
    @Published var isLoading = false
    
    private let userService: UserServiceProtocol
    private var cancellables: [AnyCancellable] = []
    private let challengeService: ChallengeServiceProtocol
    
    enum Action {
        case createChallenge
    }
    
    init(userService: UserServiceProtocol = UserService(), challengeService: ChallengeServiceProtocol = ChallengeService()) {
        self.userService = userService
        self.challengeService = challengeService
    }
    
    func send(_ action: Action) {
        switch action {
        case .createChallenge:
            isLoading = true
            currentUserId().flatMap { userId -> AnyPublisher<Void, IncrementError> in
                return self.createChallenge(userId: userId)
            }.sink { completion in
                self.isLoading = false
                switch completion {
                case let .failure(error):
                    self.error = error
                case .finished:
                    print("finished")
                }
            } receiveValue: { _ in
                print("success")
            }.store(in: &cancellables)
            
        }
    }
    
    private func createChallenge(userId: UserId) -> AnyPublisher<Void, IncrementError> {
        guard let exercise = exerciseDropdown.text,
              let startAmount = startAmountDropdown.number,
              let increase = increaseDropdown.number,
              let lenhth = lengthDropdown.number else { return Fail(error: .default(desctiption: "Parsing error")).eraseToAnyPublisher()}
        let challenge = Challenge(exercise: exercise, startAmount: startAmount, increase: increase, length: lenhth, userId: userId, startDate: Date())
        return challengeService.create(challenge).eraseToAnyPublisher()
    }
    
    private func currentUserId() -> AnyPublisher<UserId, IncrementError> {
        print("getting user id")
        return userService.currentUser().flatMap { user -> AnyPublisher<UserId, IncrementError> in
            return Fail(error: .auth(description: "some firebase auth error")).eraseToAnyPublisher()
//            if let userId = user?.uid {
//                print("user is logged in...")
//
//                return Just(userId)
//                    .setFailureType(to: IncrementError.self)
//                    .eraseToAnyPublisher()
//            } else {
//                print("user is being logged in anonymously...")
//
//                return self.userService
//                    .signInAnonymously()
//                    .map { $0.uid }
//                    .eraseToAnyPublisher()
//            }
        }.eraseToAnyPublisher()
    }
}

// MARK: Extensions

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

extension CreateChallengeViewModel.ChallengePartViewModel {
    var text: String? {
        if case let .text(text) = selectedOption.type {
            return text
        }
        return nil
    }
    var number: Int? {
        if case let .number(number) = selectedOption.type {
            return number
        }
        return nil
    }
}
