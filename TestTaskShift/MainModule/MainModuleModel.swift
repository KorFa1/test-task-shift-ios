//
//  MainModuleModel.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

protocol MainModuleModelPresenterInput: AnyObject {
    func fetchTableData()
    func fetchUserName()
    func deleteUserName()
}


protocol MainModuleModelDataManagerInput: AnyObject {
    
}

protocol MainModuleModelNetworkManagerInput: AnyObject {
    func didReceiveDataAfterReconnect(result: Result<Books, NetworkError>)
}


final class MainModuleModel {
    weak var presenter: MainModulePresenterModelInput?
    var networkManager: NetworkManagerMainModuleModelInput?
    var dataManager: DataManagerMainModuleModelInput?
    
    init(networkManager: NetworkManagerMainModuleModelInput) {
        self.networkManager = networkManager
    }
}


extension MainModuleModel: MainModuleModelPresenterInput {
    func fetchTableData() {
        networkManager?.fetchDataFromServer { [weak self] result in
            switch result {
            case .success(let books):
                self?.presenter?.didReceiveBooks(books.data)
            case .failure(let error):
                self?.presenter?.didReceiveError(error)
            }
        }
    }
    
    func fetchUserName() {
        dataManager?.fetchUserName { [weak self] userName in
            self?.presenter?.didReceiveUserName(userName)
        }
    }
    
    func deleteUserName() {
        dataManager?.deleteUserSession()
    }
}


extension MainModuleModel: MainModuleModelDataManagerInput {
    
}


extension MainModuleModel: MainModuleModelNetworkManagerInput {
    func didReceiveDataAfterReconnect(result: Result<Books, NetworkError>) {
        switch result {
        case .success(let books):
            presenter?.didReceiveBooks(books.data)
        case .failure(let error):
            presenter?.didReceiveError(error)
        }
    }
}
