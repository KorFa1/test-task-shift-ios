//
//  ValidationManager.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

protocol ValidationManagerRegistrationModuleModelInput: AnyObject {
    
}

final class ValidationManager {
    weak var registrationModuleModel: RegistrationModuleModelValidationManagerInput?
}

extension ValidationManager: ValidationManagerRegistrationModuleModelInput {
    
}
