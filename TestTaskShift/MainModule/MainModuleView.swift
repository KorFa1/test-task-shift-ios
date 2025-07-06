//
//  MainModuleView.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import UIKit
import SnapKit

protocol MainModuleViewPresenterInput: AnyObject {
    func showErrorAlert(_ text: String)
    func showGreetingsView(for userName: String)
}


final class MainModuleView: UIViewController {
    var presenter: MainModulePresenterViewInput?
    private let exitButton = UIButton(type: .system)
    private let helloButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
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


private extension MainModuleView {
    func setupUI() {

        exitButton.setTitle("Выход", for: .normal)
        exitButton.backgroundColor = .black
        exitButton.setTitleColor(.white, for: .normal)
        exitButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        exitButton.layer.cornerRadius = 8
        exitButton.layer.masksToBounds = true
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        view.addSubview(exitButton)
        
        helloButton.setTitle("Привет", for: .normal)
        helloButton.backgroundColor = .black
        helloButton.setTitleColor(.white, for: .normal)
        helloButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        helloButton.layer.cornerRadius = 8
        helloButton.layer.masksToBounds = true
        helloButton.addTarget(self, action: #selector(helloButtonTapped), for: .touchUpInside)
        view.addSubview(helloButton)
    }
    
    func setupConstraints() {
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(56)
            make.width.greaterThanOrEqualTo(110)
        }
        helloButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(56)
            make.width.greaterThanOrEqualTo(110)
        }
    }
    
    @objc func exitButtonTapped() {
        navigationController?.popViewController(animated: true)
        presenter?.exitButtonTapped()
    }
    
    @objc func helloButtonTapped() {
        presenter?.helloButtonTapped()
    }
}


extension MainModuleView: MainModuleViewPresenterInput {
    func showErrorAlert(_ text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showGreetingsView(for userName: String) {
        let greetingsView = GreetingModalViewController(userName: userName)
        present(greetingsView, animated: true, completion: nil)
    }
}

