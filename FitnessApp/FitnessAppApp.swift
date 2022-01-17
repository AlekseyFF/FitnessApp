//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 23.12.2021.
//

import SwiftUI
import Firebase

@main
struct FitnessAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        @AppStorage("isDarkMode") private var isDarkMode = false
        @StateObject private var appState = AppState()
        var body: some Scene {
            WindowGroup {
                if appState.isLoggedIn {
                    TabContainerView().preferredColorScheme(isDarkMode ? .dark : .light)
                }else {
                    LandingView()
                }
            }
        }
    }

    class AppDelegate: NSObject, UIApplicationDelegate{
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            print("setting up firebase")
            FirebaseApp.configure()
            return true
        }
    }

    class AppState: ObservableObject {
        @Published private(set) var isLoggedIn = false
        
        private let userService: UserServiceProtocol
        init(userService: UserServiceProtocol = UserService()) {
            self.userService = userService
    //        try? Auth.auth().signOut()
            self.userService.observeAuthChanges().map{$0 != nil}
                .assign(to: &$isLoggedIn)
        }
    }
