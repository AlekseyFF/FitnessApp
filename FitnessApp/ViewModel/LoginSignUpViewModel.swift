//
//  LoginSignUpViewModel.swift
//  FitnessApp
//
//  Created by Aleksey Fedorov on 10.01.2022.
//

import Combine
import Foundation

final class LoginSignupViewModel: ObservableObject {
   
    @Published var emailText = ""
    @Published var passwordText = ""
    @Published var isValid = false
    @Published var isPushed = true
    private(set) var emailPlaceHolderText = "Email"
    private(set) var passwordPlaceHolderText = "Password"
    
    private var cancellables: [AnyCancellable] = []
    private let userService: UserServiceProtocol
    private let mode: Mode
    
    init(mode : Mode, userService: UserServiceProtocol = UserService()) {
        self.mode = mode
        self.userService = userService
        
        Publishers.CombineLatest($emailText, $passwordText).map { [weak self] email, password in
            return self?.isValidEmail(email) == true && self?.isValidPassword(password) == true
        }.assign(to: &$isValid)
    }
    
    var title: String {
        switch mode {
        case .login:
            return "Welcome back!"
        case .signup:
            return "Создать аккаунт"
        }
    }
    
    var subTitle: String {
        switch mode {
        case .login:
            return "Войти по учетной записи"
        case .signup:
            return "Sign up via email"
        }
    }
    
    var buttonTitle: String {
        switch mode {
        case .login:
            return "Log in"
        case .signup:
            return "Sign up"
        }
    }
    
    func tappedActionButton() {
        switch mode {
        case .login:
            print("Login")
            userService.login(email: emailText, password: passwordText).sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("Finished")
                }
            } receiveValue: { _ in}
            .store(in: &cancellables)

        case .signup:
            userService.linkAccount(email: emailText, password: passwordText).sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    self?.isPushed = false
                }
            } receiveValue: {(_) in}
            .store(in: &cancellables)
        }
    }
}

extension LoginSignupViewModel {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email) && email.count > 5
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count > 5
    }
}

extension LoginSignupViewModel {
    enum Mode {
        case login
        case signup
    }
}
