//
//  RegistrationModuleModel.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

// MARK: - Protocols
protocol RegistrationModuleModelPresenterInput: AnyObject {
    func requestRegistrationValidation(name: String, surname: String, date: String, password: String, confirmPassword: String)
    func saveUserName()
    func checkUserSession()
}

// MARK: - RegistrationModuleModel
final class RegistrationModuleModel {
    // MARK: - Properties
    weak var presenter: RegistrationModulePresenterModelInput?
    var validationManager: ValidationManagerRegistrationModuleModelInput?
    var dataManager: DataManagerRegistrationModuleModelInput?
    private var userName: String = ""
}

// MARK: - RegistrationModuleModelPresenterInput
extension RegistrationModuleModel: RegistrationModuleModelPresenterInput {
    func requestRegistrationValidation(name: String, surname: String, date: String, password: String, confirmPassword: String) {
        userName = name
        validationManager?.validateRegistrationFields(name: name, surname: surname, date: date, password: password, confirmPassword: confirmPassword) { [weak self] validationErrors in
            self?.presenter?.didValidateRegistration(validationErrors: validationErrors)
        }
    }
    
    func saveUserName() {
        dataManager?.saveUserSession(userName: userName)
    }
    
    func checkUserSession() {
        dataManager?.fetchUserSession { [weak self] userName in
            self?.presenter?.didReceiveUserSession(userName: userName)
        }
    }
}
