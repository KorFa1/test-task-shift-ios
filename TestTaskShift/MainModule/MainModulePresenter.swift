//
//  MainModulePresenter.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation

protocol MainModulePresenterModelInput: AnyObject {
    func didReceiveBooks(_ books: [Book])
    func didReceiveError(_ error: NetworkError)
    func didReceiveUserName(_ userName: String)
}


protocol MainModulePresenterViewInput: AnyObject {
    func helloButtonTapped()
    func exitButtonTapped()
}


final class MainModulePresenter {
    var model: MainModuleModelPresenterInput?
    weak var view: MainModuleViewPresenterInput?
    
    init(model: MainModuleModelPresenterInput, view: MainModuleViewPresenterInput) {
        self.model = model
        self.view = view
        model.fetchTableData()
    }
}


extension MainModulePresenter: MainModulePresenterModelInput {
    func didReceiveBooks(_ books: [Book]) {
// MARK: - Доделать метод
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


extension MainModulePresenter: MainModulePresenterViewInput {
    func helloButtonTapped() {
        model?.fetchUserName()
    }
    
    func exitButtonTapped() {
        model?.deleteUserName()
    }
}
