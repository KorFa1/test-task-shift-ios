//
//  MainModuleModel.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

// MARK: - Protocols
protocol MainModuleModelPresenterInput: AnyObject {
    func fetchTableData()
    func fetchUserName()
    func deleteUserName()
    func fetchNumberOfBooks() -> Int
    func fetchBook(at index: Int) -> Book
}

protocol MainModuleModelNetworkManagerInput: AnyObject {
    func didReceiveDataAfterReconnect(result: Result<Books, NetworkError>)
}

// MARK: - MainModuleModel
final class MainModuleModel {
    // MARK: - Properties
    weak var presenter: MainModulePresenterModelInput?
    var networkManager: NetworkManagerMainModuleModelInput?
    var dataManager: DataManagerMainModuleModelInput?
    private var books: [Book] = []
    
    // MARK: - Init
    init(networkManager: NetworkManagerMainModuleModelInput) {
        self.networkManager = networkManager
    }
    
}

// MARK: - MainModuleModelPresenterInput
extension MainModuleModel: MainModuleModelPresenterInput {
    func fetchTableData() {
        networkManager?.fetchDataFromServer { [weak self] result in
            switch result {
            case .success(let books):
                self?.books = books.data
                self?.presenter?.didReceiveBooks()
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
    
    func fetchNumberOfBooks() -> Int {
        return books.count
    }
    
    func fetchBook(at index: Int) -> Book {
        return books[index]
    }
}

// MARK: - MainModuleModelNetworkManagerInput
extension MainModuleModel: MainModuleModelNetworkManagerInput {
    func didReceiveDataAfterReconnect(result: Result<Books, NetworkError>) {
        switch result {
        case .success(let books):
            self.books = books.data
            presenter?.didReceiveBooks()
        case .failure(let error):
            presenter?.didReceiveError(error)
        }
    }
}
