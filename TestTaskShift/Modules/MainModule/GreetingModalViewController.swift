//
//  GreetingModalViewController.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 06.07.2025.
//

import UIKit
import SnapKit

// MARK: - GreetingModalViewController
final class GreetingModalViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let greetingFontSize: CGFloat = 50
        static let greetingNumberOfLines: Int = 0
        static let sheetCornerRadius: CGFloat = 24
    }

    // MARK: - Properties
    private let userName: String
    private let greetingLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSheetPresentation()
    }
    
    // MARK: - Init
    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
private extension GreetingModalViewController {
    func setupUI() {
        setupBaseUI()
        createGreetingLabel()
    }
    
    func setupBaseUI() {
        view.backgroundColor = .systemGray
    }
    
    func createGreetingLabel() {
        greetingLabel.textColor = .black
        greetingLabel.font = .systemFont(ofSize: Constants.greetingFontSize, weight: .bold)
        greetingLabel.textAlignment = .center
        greetingLabel.numberOfLines = Constants.greetingNumberOfLines
        greetingLabel.text = "Привет, \(userName)!"
        view.addSubview(greetingLabel)
    }

}

// MARK: - Constraints
private extension GreetingModalViewController {
    func setupConstraints() {
        greetingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Sheet Presentation
private extension GreetingModalViewController {
    func setupSheetPresentation() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = Constants.sheetCornerRadius
        }
    }
}
