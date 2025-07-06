//
//  RegistrationModulePresenter.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

protocol RegistrationModulePresenterModelInput: AnyObject {
    func didValidateRegistration(validationErrors: [ValidationError])
    func didReceiveUserSession(userName: String?)
}


protocol RegistrationModulePresenterViewInput: AnyObject {
    func didTapRegistrationButton(name: String, surname: String, date: String, password: String, confirmPassword: String)
    func RegistrationModuleViewDidLoad()
}


final class RegistrationModulePresenter {
    var model: RegistrationModuleModelPresenterInput?
    weak var view: RegistrationModuleViewPresenterInput?
    var moduleManager: ModuleManagerRegistrationModulePresenterInput?
    
    init(model: RegistrationModuleModelPresenterInput, view: RegistrationModuleViewPresenterInput, moduleManager: ModuleManagerRegistrationModulePresenterInput) {
        self.model = model
        self.view = view
        self.moduleManager = moduleManager
    }
}
   

extension RegistrationModulePresenter: RegistrationModulePresenterModelInput {
    func didValidateRegistration(validationErrors: [ValidationError]) {
        view?.showNameError(error: "")
        view?.showSurnameError(error: "")
        view?.showDateError(error: "")
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
            case .underage:
                view?.showDateError(error: "Вам должно быть не менее 12 лет")
            case .overage:
                view?.showDateError(error: "Вам должно быть не более 130 лет")
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


extension RegistrationModulePresenter: RegistrationModulePresenterViewInput {
    func didTapRegistrationButton(name: String, surname: String, date: String, password: String, confirmPassword: String) {
        model?.requestRegistrationValidation(name: name, surname: surname, date: date, password: password, confirmPassword: confirmPassword)
    }
    
    func RegistrationModuleViewDidLoad() {
        model?.checkUserSession()
    }
}
