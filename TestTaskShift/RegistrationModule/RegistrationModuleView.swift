//
//  RegistrationModuleView.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import UIKit

protocol RegistrationModuleViewPresenterInput: AnyObject {
    
}

final class RegistrationModuleView: UIViewController {
    var presenter: RegistrationModulePresenterViewInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }
}

extension RegistrationModuleView: RegistrationModuleViewPresenterInput {
    
}
