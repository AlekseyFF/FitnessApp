//
//  ChallengeService.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 28.12.2021.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ChallengeServiceProtocol {
    func create(_ challenge: Challenge) -> AnyPublisher<Void, IncrementError>
}

final class ChallengeService: ChallengeServiceProtocol {
    private let db = Firestore.firestore()
    func create(_ challenge: Challenge) -> AnyPublisher<Void, IncrementError> {
        return Future<Void, IncrementError> { promise in
            do {
                _ = try self.db.collection("challenges").addDocument(from: challenge) { error in
                    if let error = error {
                        promise(.failure(.default(desctiption: error.localizedDescription)))
                    } else {
                        promise(.success(()))
                    }
                }
                promise(.success(()))
            } catch {
                promise(.failure(.default()))
            }
        }.eraseToAnyPublisher()
    }
}