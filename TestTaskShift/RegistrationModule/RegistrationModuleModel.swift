//
//  RegistrationModuleModel.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

protocol RegistrationModuleModelPresenterInput: AnyObject {
    func requestRegistrationValidation(name: String, surname: String, date: String, password: String, confirmPassword: String)
}

protocol RegistrationModuleModelDataManagerInput: AnyObject {
    
}

final class RegistrationModuleModel {
    weak var presenter: RegistrationModulePresenterModelInput?
    var validationManager: ValidationManagerRegistrationModuleModelInput?
    var dataManager: DataManagerRegistrationModuleModelInput?
}

extension RegistrationModuleModel: RegistrationModuleModelPresenterInput {
    func requestRegistrationValidation(name: String, surname: String, date: String, password: String, confirmPassword: String) {
        validationManager?.validateRegistrationFields(name: name, surname: surname, date: date, password: password, confirmPassword: confirmPassword) { [weak self] validationErrors in
            self?.presenter?.didValidateRegistration(validationErrors: validationErrors)
        }
    }
}

extension RegistrationModuleModel: RegistrationModuleModelDataManagerInput {
    
}
