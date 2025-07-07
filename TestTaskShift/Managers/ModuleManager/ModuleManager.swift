//
//  ModuleManager.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import UIKit

// MARK: - Protocols
protocol ModuleManagerSceneDelegateInput: AnyObject {
    func createRegistrationModule() -> UIViewController
}

protocol ModuleManagerRegistrationModulePresenterInput: AnyObject {
    func createMainModule() -> UIViewController
}

// MARK: - ModuleManager
final class ModuleManager {
    // MARK: - Properties
    private let dataManager: DataManagerRegistrationModuleModelInput & DataManagerMainModuleModelInput = DataManager()
}

// MARK: - ModuleManagerSceneDelegateInput
extension ModuleManager: ModuleManagerSceneDelegateInput {
    func createRegistrationModule() -> UIViewController {
        let registrationModuleModel: RegistrationModuleModelPresenterInput = RegistrationModuleModel()
        let registrationModuleView: RegistrationModuleViewPresenterInput = RegistrationModuleView()
        let validationManager: ValidationManagerRegistrationModuleModelInput = ValidationManager()
        let registrationModulePresenter: RegistrationModulePresenterModelInput & RegistrationModulePresenterViewInput = RegistrationModulePresenter(model: registrationModuleModel, view: registrationModuleView, moduleManager: self as ModuleManagerRegistrationModulePresenterInput)
        
        (registrationModuleModel as! RegistrationModuleModel).presenter = registrationModulePresenter
        (registrationModuleModel as! RegistrationModuleModel).validationManager = validationManager
        (registrationModuleModel as! RegistrationModuleModel).dataManager = dataManager
        
        (registrationModuleView as! RegistrationModuleView).presenter = registrationModulePresenter
        
        return registrationModuleView as! UIViewController
    }
}
    
// MARK: - ModuleManagerRegistrationModulePresenterInput
extension ModuleManager: ModuleManagerRegistrationModulePresenterInput {
    func createMainModule() -> UIViewController {
        let networkManager: NetworkManagerMainModuleModelInput = NetworkManager()
        let mainModuleModel: MainModuleModelPresenterInput & MainModuleModelNetworkManagerInput = MainModuleModel(networkManager: networkManager)
        let mainModuleView: MainModuleViewPresenterInput = MainModuleView()
        let mainModulePresenter: MainModulePresenterModelInput & MainModulePresenterViewInput = MainModulePresenter(model: mainModuleModel, view: mainModuleView)
        
        (mainModuleModel as! MainModuleModel).presenter = mainModulePresenter
        (mainModuleModel as! MainModuleModel).networkManager = networkManager
        (mainModuleModel as! MainModuleModel).dataManager = dataManager
        
        (mainModuleView as! MainModuleView).presenter = mainModulePresenter
        
        (networkManager as! NetworkManager).mainModuleModel = mainModuleModel
        
        return mainModuleView as! UIViewController
    }
}
