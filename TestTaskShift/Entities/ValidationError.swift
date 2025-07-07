//
//  ValidationError.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 05.07.2025.
//

import Foundation

enum ValidationError {
    case invalidName
    case invalidSurname
    case passwordTooShort
    case passwordNoNumber
    case passwordNoLetter
    case passwordsDontMatch
}
