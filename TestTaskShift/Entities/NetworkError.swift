//
//  NetworkError.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 06.07.2025.
//

import Foundation

enum NetworkError: Error {
    case internalError
    case connectionError
    case serverError
    case unknownError
}
