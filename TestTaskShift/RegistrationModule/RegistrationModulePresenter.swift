//
//  RegistrationModulePresenter.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

protocol RegistrationModulePresenterModelInput: AnyObject {
    
}

protocol RegistrationModulePresenterViewInput: AnyObject {
    
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
    
}

extension RegistrationModulePresenter: RegistrationModulePresenterViewInput {
    
}
