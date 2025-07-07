//
//  MainModulePresenter.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

// MARK: - Protocols
protocol MainModulePresenterModelInput: AnyObject {
    func didReceiveBooks()
    func didReceiveError(_ error: NetworkError)
    func didReceiveUserName(_ userName: String)
}

protocol MainModulePresenterViewInput: AnyObject {
    func helloButtonTapped()
    func exitButtonTapped()
    func getNumberOfBooks() -> Int
    func getBook(at index: Int) -> Book
}

// MARK: - MainModulePresenter
final class MainModulePresenter {
    // MARK: - Properties
    var model: MainModuleModelPresenterInput?
    weak var view: MainModuleViewPresenterInput?
    
    // MARK: - Init
    init(model: MainModuleModelPresenterInput, view: MainModuleViewPresenterInput) {
        self.model = model
        self.view = view
        model.fetchTableData()
    }
}

// MARK: - MainModulePresenterModelInput
extension MainModulePresenter: MainModulePresenterModelInput {
    func didReceiveBooks() {
        view?.showBooks()
    }
    
    func didReceiveError(_ error: NetworkError) {
        switch error {
        case .connectionError:
            view?.showErrorAlert("Нет интернет соединения")
        case .serverError:
            view?.showErrorAlert("Ошибка сервера")
        case .internalError:
            view?.showErrorAlert("Внутренняя ошибка приложения")
        case .unknownError:
            view?.showErrorAlert("Неизвестная ошибка")
        }
    }
    
    func didReceiveUserName(_ userName: String) {
        view?.showGreetingsView(for: userName)
    }
}

// MARK: - MainModulePresenterViewInput
extension MainModulePresenter: MainModulePresenterViewInput {
    func helloButtonTapped() {
        model?.fetchUserName()
    }
    
    func exitButtonTapped() {
        model?.deleteUserName()
        view?.navigateToRegistrationModule()
    }
    
    func getNumberOfBooks() -> Int {
        return model?.fetchNumberOfBooks() ?? 0
    }
    
    func getBook(at index: Int) -> Book {
        model?.fetchBook(at: index) ?? Book(title: "None", author: "None")
    }
}
