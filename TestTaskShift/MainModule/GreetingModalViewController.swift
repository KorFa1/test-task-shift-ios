//
//  GreetingModalViewController.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 06.07.2025.
//

import UIKit
import SnapKit

final class GreetingModalViewController: UIViewController {
    private let userName: String

    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 50, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        greetingLabel.text = "Привет, \(userName)!"

        view.addSubview(greetingLabel)
        greetingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(24)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
    }
}
