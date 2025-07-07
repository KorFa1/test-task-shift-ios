//
//  RegistrationModulePresenter.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

// MARK: - Protocols
protocol RegistrationModulePresenterModelInput: AnyObject {
    func didValidateRegistration(validationErrors: [ValidationError])
    func didReceiveUserSession(userName: String?)
}

protocol RegistrationModulePresenterViewInput: AnyObject {
    func didTapRegistrationButton(name: String, surname: String, date: String, password: String, confirmPassword: String)
    func registrationModuleViewDidLoad()
}

// MARK: - RegistrationModulePresenter
final class RegistrationModulePresenter {
    // MARK: - Properties
    var model: RegistrationModuleModelPresenterInput?
    weak var view: RegistrationModuleViewPresenterInput?
    var moduleManager: ModuleManagerRegistrationModulePresenterInput?
    
    // MARK: - Init
    init(model: RegistrationModuleModelPresenterInput, view: RegistrationModuleViewPresenterInput, moduleManager: ModuleManagerRegistrationModulePresenterInput) {
        self.model = model
        self.view = view
        self.moduleManager = moduleManager
    }
}
   
// MARK: - RegistrationModulePresenterModelInput
extension RegistrationModulePresenter: RegistrationModulePresenterModelInput {
    func didValidateRegistration(validationErrors: [ValidationError]) {
        view?.showNameError(error: "")
        view?.showSurnameError(error: "")
        view?.showPasswordError(error: "")
        view?.showConfirmPasswordError(error: "")
        
        if validationErrors.isEmpty {
            model?.saveUserName()
            
            let mainModule = moduleManager?.createMainModule()
            if let mainModule {
                view?.navigateToMainModule(mainModule)
            }
        }

        for error in validationErrors {
            switch error {
            case .invalidName:
                view?.showNameError(error: "Некорректное имя")
            case .invalidSurname:
                view?.showSurnameError(error: "Некорректная фамилия")
            case .passwordTooShort:
                view?.showPasswordError(error: "Пароль слишком короткий")
            case .passwordNoNumber:
                view?.showPasswordError(error: "Пароль должен содержать цифру")
            case .passwordNoLetter:
                view?.showPasswordError(error: "Пароль должен содержать букву")
            case .passwordsDontMatch:
                view?.showConfirmPasswordError(error: "Пароли не совпадают")
            }
        }
    }
    
    func didReceiveUserSession(userName: String?) {
        if let userName = userName, let mainModule = moduleManager?.createMainModule() {
            view?.navigateToMainModule(mainModule)
        }
    }
}

// MARK: - RegistrationModulePresenterViewInput
extension RegistrationModulePresenter: RegistrationModulePresenterViewInput {
    func didTapRegistrationButton(name: String, surname: String, date: String, password: String, confirmPassword: String) {
        model?.requestRegistrationValidation(name: name, surname: surname, date: date, password: password, confirmPassword: confirmPassword)
    }
    
    func registrationModuleViewDidLoad() {
        model?.checkUserSession()
    }
}
