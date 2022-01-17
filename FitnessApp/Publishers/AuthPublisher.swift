//
//  AuthPublisher.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 28.12.2021.
//

import Combine
import FirebaseAuth

extension Publishers {
    struct AuthPublisher: Publisher {
        typealias Output = User?
        typealias Failure = Never
        
        func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let authSubcription = AuthSubscription(subscriber: subscriber)
            subscriber.receive(subscription: authSubcription)
        }
    }
    
    class AuthSubscription<S: Subscriber>: Subscription where S.Input == User?, S.Failure == Never {
        private var subscriber: S?
        private var handler: AuthStateDidChangeListenerHandle?
        init(subscriber: S) {
            self.subscriber = subscriber
            handler = Auth.auth().addStateDidChangeListener { auth, user in
                _ = subscriber.receive(user)
            }
        }
        func request(_ demand: Subscribers.Demand) {}
        func cancel() {
            subscriber = nil
            handler = nil
        }
    }
}
