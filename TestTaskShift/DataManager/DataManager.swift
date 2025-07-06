//
//  DataManager.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

protocol DataManagerRegistrationModuleModelInput: AnyObject {
    func saveUserSession(userName: String)
    func fetchUserSession(completion: @escaping (String?) -> Void)
}


protocol DataManagerMainModuleModelInput: AnyObject {
    func fetchUserName(completion: @escaping (String) -> Void)
    func deleteUserSession()
}


final class DataManager {
    weak var registrationModuleModel: RegistrationModuleModelDataManagerInput?
    weak var mainModuleModel: MainModuleModelDataManagerInput?
    private let userDefaultsKey: String = "userName"
}


extension DataManager: DataManagerRegistrationModuleModelInput {
    func saveUserSession(userName: String) {
        UserDefaults.standard.set(userName, forKey: userDefaultsKey)
    }
    
    func fetchUserSession(completion: @escaping (String?) -> Void) {
        let userName = UserDefaults.standard.string(forKey: userDefaultsKey)
        DispatchQueue.main.async {
            completion(userName)
        }
    }
}


extension DataManager: DataManagerMainModuleModelInput {
    func fetchUserName(completion: @escaping (String) -> Void) {
        if let userName = UserDefaults.standard.string(forKey: userDefaultsKey) {
            DispatchQueue.main.async {
                completion(userName)
            }
        }
    }
    
    func deleteUserSession() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
