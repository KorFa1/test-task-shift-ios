//
//  DataManager.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

protocol DataManagerRegistrationModuleModelInput: AnyObject {
    
}


protocol DataManagerMainModuleModelInput: AnyObject {
    
}


final class DataManager {
    weak var registrationModuleModel: RegistrationModuleModelDataManagerInput?
    weak var mainModuleModel: MainModuleModelDataManagerInput?
}


extension DataManager: DataManagerRegistrationModuleModelInput {
    
}


extension DataManager: DataManagerMainModuleModelInput {
    
}
