//
//  MainModuleView.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import UIKit
import SnapKit

// MARK: - Protocols
protocol MainModuleViewPresenterInput: AnyObject {
    func showErrorAlert(_ text: String)
    func showGreetingsView(for userName: String)
    func showBooks()
    func navigateToRegistrationModule()
}

// MARK: - MainModuleView
final class MainModuleView: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let identifier: String = "MainModuleView"
        static let buttonTopOffset: CGFloat = 48
        static let buttonSideInset: CGFloat = 24
        static let buttonHeight: CGFloat = 56
        static let buttonMinWidth: CGFloat = 110
        static let tableTopOffset: CGFloat = 24
        static let tableRowHeight: CGFloat = 100
        static let exitButtonTitle = "Выход"
        static let helloButtonTitle = "Привет"
        static let errorAlertTitle = "Ошибка"
        static let errorAlertOk = "ОК"
    }

    // MARK: - Properties
    var presenter: MainModulePresenterViewInput?
    
    private let exitButton = UIButton(type: .system)
    private let helloButton = UIButton(type: .system)
    private let tableView = UITableView()
    private var isLoading = true
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        showLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

// MARK: - UI Setup
private extension MainModuleView {
    func setupUI() {
        setupBaseUI()
        setupExitButton()
        setupHelloButton()
        setupTableView()
        setupLoadingView()
    }

    func setupBaseUI() {
        view.backgroundColor = .systemBackground
    }

    func setupExitButton() {
        exitButton.setTitle(Constants.exitButtonTitle, for: .normal)
        exitButton.backgroundColor = .black
        exitButton.setTitleColor(.white, for: .normal)
        exitButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        exitButton.layer.cornerRadius = 8
        exitButton.layer.masksToBounds = true
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        view.addSubview(exitButton)
    }

    func setupHelloButton() {
        helloButton.setTitle(Constants.helloButtonTitle, for: .normal)
        helloButton.backgroundColor = .black
        helloButton.setTitleColor(.white, for: .normal)
        helloButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        helloButton.layer.cornerRadius = 8
        helloButton.layer.masksToBounds = true
        helloButton.addTarget(self, action: #selector(helloButtonTapped), for: .touchUpInside)
        view.addSubview(helloButton)
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = Constants.tableRowHeight
        tableView.separatorStyle = .none
        tableView.register(TableViewCell.self, forCellReuseIdentifier: Constants.identifier)
        view.addSubview(tableView)
    }
    
    func setupLoadingView() {
        loadingView.hidesWhenStopped = true
        loadingView.color = .systemGray
        view.addSubview(loadingView)
    }
}

// MARK: - Constraints
private extension MainModuleView {
    func setupConstraints() {
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.buttonTopOffset)
            make.left.equalToSuperview().offset(Constants.buttonSideInset)
            make.height.equalTo(Constants.buttonHeight)
            make.width.greaterThanOrEqualTo(Constants.buttonMinWidth)
        }
        helloButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.buttonTopOffset)
            make.right.equalToSuperview().inset(Constants.buttonSideInset)
            make.height.equalTo(Constants.buttonHeight)
            make.width.greaterThanOrEqualTo(Constants.buttonMinWidth)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(exitButton.snp.bottom).offset(Constants.tableTopOffset)
            make.left.right.bottom.equalToSuperview()
        }
        loadingView.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
    }
}

// MARK: - Actions
private extension MainModuleView {
    @objc func exitButtonTapped() {
        presenter?.exitButtonTapped()
    }
    
    @objc func helloButtonTapped() {
        presenter?.helloButtonTapped()
    }
}

// MARK: - Loading
private extension MainModuleView {
    func showLoading() {
        isLoading = true
        tableView.isUserInteractionEnabled = false
        loadingView.startAnimating()
        tableView.reloadData()
    }
    
    func hideLoading() {
        isLoading = false
        tableView.isUserInteractionEnabled = true
        loadingView.stopAnimating()
        tableView.reloadData()
    }
}

// MARK: - MainModuleViewPresenterInput
extension MainModuleView: MainModuleViewPresenterInput {
    func showErrorAlert(_ text: String) {
        let alert = UIAlertController(title: Constants.errorAlertTitle, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.errorAlertOk, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showGreetingsView(for userName: String) {
        let greetingsView = GreetingModalViewController(userName: userName)
        present(greetingsView, animated: true, completion: nil)
    }
    
    func showBooks() {
        hideLoading()
    }
    
    func navigateToRegistrationModule() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate
extension MainModuleView: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else {
            return presenter?.getNumberOfBooks() ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableRowHeight
    }
}

// MARK: - UITableViewDataSource
extension MainModuleView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath) as! TableViewCell
        if let book = presenter?.getBook(at: indexPath.row) {
            cell.configure(title: book.title, author: book.author)
        }
        return cell
    }
}
