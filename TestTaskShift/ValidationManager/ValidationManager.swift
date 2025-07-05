//
//  ValidationManager.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

protocol ValidationManagerRegistrationModuleModelInput: AnyObject {
    func validateRegistrationFields(name: String, surname: String, date: String, password: String, confirmPassword: String, completion: @escaping ([ValidationError]) -> Void)
}

final class ValidationManager {

}

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
        
// MARK: - подумать над датой
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let userDate = dateFormatter.date(from: date)!
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: userDate, to: now)
        let age = ageComponents.year ?? 0
        if age < 12 {
            errors.append(.underage)
        } else if age > 130 {
            errors.append(.overage)
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
