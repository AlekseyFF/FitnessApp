//
//  ChallengeListViewModel.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 29.12.2021.
//

import SwiftUI
import Combine

final class ChallengeListViewModel: ObservableObject {
    private let userService: UserServiceProtocol
    private let challengeService: ChallengeServiceProtocol
    private var cancellable: [AnyCancellable] = []
    @Published private(set) var itemsViewModels: [ChallengeItemViewModel] = []
    @Published private(set) var error: IncrementError?
    @Published private(set) var isLoading = false
    @Published var showingCreateModal = false
    let title = "Challenges"
    enum Action {
        case retry
        case create
        case timeChange
    }
    
    init(userService: UserServiceProtocol = UserService(),
         challengeService: ChallengeServiceProtocol = ChallengeService()) {
        self.userService = userService
        self.challengeService = challengeService
        observeChallenges()
    }
    func send(action: Action) {
        switch action {
        case .retry:
            observeChallenges()
        case .create:
            showingCreateModal = true
        case .timeChange:
            cancellable.removeAll()
            observeChallenges()
        }
    }
    private func observeChallenges() {
        isLoading = true
        userService.currentUserPublisher().compactMap {
            $0?.uid
        }.flatMap { [weak self] userId -> AnyPublisher<[Challenge], IncrementError> in
            guard let self = self else { return Fail(error: .default()).eraseToAnyPublisher()}
            return self.challengeService.observeChallenges(userId: userId)
        }.sink { [weak self] completion in
            guard let self = self else { return}
            self.isLoading = false
            switch completion  {
            case let .failure(error):
                self.error = error
            case .finished:
                print("Finished")
            }
        } receiveValue: { [weak self] challenges in
            guard let self = self else { return}
            self.isLoading = false
            self.error = nil
            self.showingCreateModal = false
            self.itemsViewModels = challenges.map{ challenge in
                .init(challenge, onDelete: { [weak self] id in
                    self?.deleteChallenge(id)
                }, onToggleComplete: { [weak self] id, activities in
                    self?.updateChallenge(id: id, activities: activities)
                })
            }
        }.store(in: &cancellable)
    }
    
    private func deleteChallenge(_ challengeId: String) {
        challengeService.delete(challengeId).sink { completion in
            switch completion {
            case let .failure(error):
                print(error.localizedDescription)
            case .finished:
                print("Finished")
                break
            }
        } receiveValue: { _ in }
        .store(in: &cancellable)
    }
    
    private func updateChallenge(id: String, activities: [Activity]) {
        challengeService.updateChallenge(challengeId: id, activities: activities).sink { (completion) in
            switch completion {
            case let .failure(error):
                print(error.localizedDescription)
            case .finished:
                print("Finished")
                break
            }
        } receiveValue: { _ in }
        .store(in: &cancellable)
    }
    
}
