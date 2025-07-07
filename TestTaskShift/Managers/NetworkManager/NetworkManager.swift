//
//  NetworkManager.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import Foundation
import Network

// MARK: - Protocols
protocol NetworkManagerMainModuleModelInput: AnyObject {
    func fetchDataFromServer(completion: @escaping (Result<Books, NetworkError>) -> Void)
}

// MARK: - NetworkManager
final class NetworkManager {
    // MARK: - Properties
    weak var mainModuleModel: MainModuleModelNetworkManagerInput?
    private let urlString = "https://fakerapi.it/api/v1/books"
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    private var isConnected: Bool = true
    private var pendingRequest: (() -> Void)?
    
    // MARK: - Init
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            if self?.isConnected == true {
                self?.performPendingRequest()
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}

// MARK: - Private Methods
private extension NetworkManager {
    func performPendingRequest() {
        if let request = pendingRequest {
            pendingRequest = nil
            request()
        }
    }
    
    func performRequestAndSendToModel() {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.mainModuleModel?.didReceiveDataAfterReconnect(result: .failure(.internalError))
            }
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error as? URLError, error.code == .notConnectedToInternet {
                DispatchQueue.main.async {
                    self?.mainModuleModel?.didReceiveDataAfterReconnect(result: .failure(.connectionError))
                }
                return
            } else if let error = error {
                DispatchQueue.main.async {
                    self?.mainModuleModel?.didReceiveDataAfterReconnect(result: .failure(.unknownError))
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self?.mainModuleModel?.didReceiveDataAfterReconnect(result: .failure(.internalError))
                }
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self?.mainModuleModel?.didReceiveDataAfterReconnect(result: .failure(.serverError))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.mainModuleModel?.didReceiveDataAfterReconnect(result: .failure(.internalError))
                }
                return
            }
            do {
                let books = try JSONDecoder().decode(Books.self, from: data)
                DispatchQueue.main.async {
                    self?.mainModuleModel?.didReceiveDataAfterReconnect(result: .success(books))
                }
            } catch {
                DispatchQueue.main.async {
                    self?.mainModuleModel?.didReceiveDataAfterReconnect(result: .failure(.internalError))
                }
            }
        }.resume()
    }
}

// MARK: - NetworkManagerMainModuleModelInput
extension NetworkManager: NetworkManagerMainModuleModelInput {
    func fetchDataFromServer(completion: @escaping (Result<Books, NetworkError>) -> Void) {
        if !isConnected {
            pendingRequest = { [weak self] in
                self?.performRequestAndSendToModel()
            }
            DispatchQueue.main.async {
                completion(.failure(.connectionError))
            }
            return
        }
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(.internalError))
            }
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.unknownError))
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.internalError))
                }
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.internalError))
                }
                return
            }
            do {
                let books = try JSONDecoder().decode(Books.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(books))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.internalError))
                }
            }
        }.resume()
    }
}
