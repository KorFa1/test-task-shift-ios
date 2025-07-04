//
//  RegistrationModuleModel.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

protocol RegistrationModuleModelPresenterInput: AnyObject {
    
}

protocol RegistrationModuleModelValidationManagerInput: AnyObject {
    
}

protocol RegistrationModuleModelDataManagerInput: AnyObject {
    
}

final class RegistrationModuleModel {
    weak var presenter: RegistrationModulePresenterModelInput?
    var validationManager: ValidationManagerRegistrationModuleModelInput?
    var dataManager: DataManagerRegistrationModuleModelInput?
}

extension RegistrationModuleModel: RegistrationModuleModelPresenterInput {
    
}

extension RegistrationModuleModel: RegistrationModuleModelValidationManagerInput {
    
}

extension RegistrationModuleModel: RegistrationModuleModelDataManagerInput {
    
}
