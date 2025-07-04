//
//  ModuleManager.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import UIKit

protocol ModuleManagerSceneDelegateInput: AnyObject {
    func createRegistrationModule() -> UIViewController
}


protocol ModuleManagerRegistrationModulePresenterInput: AnyObject {
    func createMainModule() -> UIViewController
}


final class ModuleManager {
    
}


extension ModuleManager: ModuleManagerSceneDelegateInput {
    
    func createRegistrationModule() -> UIViewController {
        let registrationModuleModel: RegistrationModuleModelPresenterInput & RegistrationModuleModelValidationManagerInput & RegistrationModuleModelDataManagerInput = RegistrationModuleModel()
        let registrationModuleView: RegistrationModuleViewPresenterInput = RegistrationModuleView()
        let validationManager: ValidationManagerRegistrationModuleModelInput = ValidationManager()
        let dataManager: DataManagerRegistrationModuleModelInput & DataManagerMainModuleModelInput = DataManager()
        let registrationModulePresenter: RegistrationModulePresenterModelInput & RegistrationModulePresenterViewInput = RegistrationModulePresenter(model: registrationModuleModel, view: registrationModuleView, moduleManager: self as ModuleManagerRegistrationModulePresenterInput)
        
        (registrationModuleModel as! RegistrationModuleModel).presenter = registrationModulePresenter
        (registrationModuleModel as! RegistrationModuleModel).validationManager = validationManager
        (registrationModuleModel as! RegistrationModuleModel).dataManager = dataManager
        
        (registrationModuleView as! RegistrationModuleView).presenter = registrationModulePresenter
        
        (validationManager as! ValidationManager).registrationModuleModel = registrationModuleModel
        (dataManager as! DataManager).registrationModuleModel = registrationModuleModel
        
        return registrationModuleView as! UIViewController
    }
}
    

extension ModuleManager: ModuleManagerRegistrationModulePresenterInput {
    
    func createMainModule() -> UIViewController {
        return UIViewController()
    }
}
