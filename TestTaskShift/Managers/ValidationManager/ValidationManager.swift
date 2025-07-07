//
//  ValidationManager.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

// MARK: - Protocols
protocol ValidationManagerRegistrationModuleModelInput: AnyObject {
    func validateRegistrationFields(name: String, surname: String, date: String, password: String, confirmPassword: String, completion: @escaping ([ValidationError]) -> Void)
}

// MARK: - ValidationManager
final class ValidationManager {

}

// MARK: - ValidationManagerRegistrationModuleModelInput
extension ValidationManager: ValidationManagerRegistrationModuleModelInput {
    func validateRegistrationFields(name: String, surname: String, date: String, password: String, confirmPassword: String, completion: @escaping ([ValidationError]) -> Void) {
        var errors: [ValidationError] = []
        
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedSurname = surname.trimmingCharacters(in: .whitespaces)

        if trimmedName.count < 2 || !trimmedName.allSatisfy({ $0.isLetter }) {
            errors.append(.invalidName)
        }

        if trimmedSurname.count < 2 || !trimmedSurname.allSatisfy({ $0.isLetter }) {
            errors.append(.invalidSurname)
        }
        
        if password.rangeOfCharacter(from: .decimalDigits) == nil {
            errors.append(.passwordNoNumber)
        }
        
        if password.rangeOfCharacter(from: .letters) == nil {
            errors.append(.passwordNoLetter)
        }
        
        if password.count < 8 {
            errors.append(.passwordTooShort)
        }

        if password != confirmPassword {
            errors.append(.passwordsDontMatch)
        }

        DispatchQueue.main.async {
            completion(errors)
        }
    }
}
