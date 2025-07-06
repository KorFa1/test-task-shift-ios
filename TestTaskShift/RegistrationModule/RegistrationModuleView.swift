//
//  RegistrationModuleView.swift
//  TestTaskShift
//
//  Created by Кирилл Софрин on 04.07.2025.
//

import UIKit
import SnapKit

protocol RegistrationModuleViewPresenterInput: AnyObject {
    func showNameError(error: String)
    func showSurnameError(error: String)
    func showDateError(error: String)
    func showPasswordError(error: String)
    func showConfirmPasswordError(error: String)
    func navigateToMainModule(_ viewController: UIViewController)
}

// MARK: - Constants
private enum Constants {
    static let fieldTopOffset: CGFloat = 32
    static let fieldSideInset: CGFloat = 24
    static let fieldHeight: CGFloat = 48
    static let errorLabelTopOffset: CGFloat = 2
    static let errorLabelHeight: CGFloat = 16
    static let fieldVerticalSpacing: CGFloat = 20
    static let buttonTopOffset: CGFloat = 40
    static let buttonHeight: CGFloat = 52
    static let buttonBottomOffset: CGFloat = 32
    static let errorLabelFontSize: CGFloat = 10
    static let navTitle = "Регистрация"
    static let namePlaceholder = "Введите имя"
    static let surnamePlaceholder = "Введите фамилию"
    static let datePlaceholder = "ДД/ММ/ГГГГ"
    static let passwordPlaceholder = "Введите пароль"
    static let confirmPasswordPlaceholder = "Подтвердите пароль"
    static let registerButtonTitle = "Зарегистрироваться"
}

// MARK: - RegistrationModuleView
final class RegistrationModuleView: UIViewController {
    
// MARK: - Properties
    var presenter: RegistrationModulePresenterViewInput?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let nameTextField = UITextField()
    private let surnameTextField = UITextField()
    private let dateTextField = UITextField()
    private let datePicker = UIDatePicker()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let registerButton = UIButton(type: .system)
    
    private var isPasswordVisible = false
    private var isConfirmPasswordVisible = false
    
    private let nameErrorLabel = UILabel()
    private let surnameErrorLabel = UILabel()
    private let dateErrorLabel = UILabel()
    private let passwordErrorLabel = UILabel()
    private let confirmPasswordErrorLabel = UILabel()
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupKeyboardNotifications()
        
        presenter?.RegistrationModuleViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI Setup
private extension RegistrationModuleView {
    func setupUI() {
        setupBaseUI()
        createNameTextField()
        createSurnameTextField()
        createDateTextField()
        createPasswordTextField()
        createConfirmPasswordTextField()
        createRegisterButton()
        createErrorLabels()
    }
    
    func setupBaseUI() {
        view.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    func createNameTextField() {
        nameTextField.placeholder = Constants.namePlaceholder
        nameTextField.borderStyle = .roundedRect
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        contentView.addSubview(nameTextField)
    }
    
    func createSurnameTextField() {
        surnameTextField.placeholder = Constants.surnamePlaceholder
        surnameTextField.borderStyle = .roundedRect
        surnameTextField.delegate = self
        surnameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        contentView.addSubview(surnameTextField)
    }
    
    func createDateTextField() {
        dateTextField.placeholder = Constants.datePlaceholder
        dateTextField.borderStyle = .roundedRect
        dateTextField.rightViewMode = .always
        let calendarImage = UIImageView(image: UIImage(systemName: "calendar"))
        calendarImage.tintColor = .black
        dateTextField.rightView = calendarImage
        dateTextField.delegate = self
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        contentView.addSubview(dateTextField)
    }
    
    func createPasswordTextField() {
        passwordTextField.placeholder = Constants.passwordPlaceholder
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addPasswordToggle(to: passwordTextField, selector: #selector(togglePasswordVisibility))
        contentView.addSubview(passwordTextField)
    }
    
    func createConfirmPasswordTextField() {
        confirmPasswordTextField.placeholder = Constants.confirmPasswordPlaceholder
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addPasswordToggle(to: confirmPasswordTextField, selector: #selector(toggleConfirmPasswordVisibility))
        contentView.addSubview(confirmPasswordTextField)
    }
    
    func createRegisterButton() {
        registerButton.setTitle(Constants.registerButtonTitle, for: .normal)
        registerButton.backgroundColor = .systemGray
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        registerButton.layer.cornerRadius = 8
        registerButton.isEnabled = false
        registerButton.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        contentView.addSubview(registerButton)
    }
    
    func createErrorLabels() {
        nameErrorLabel.font = .systemFont(ofSize: Constants.errorLabelFontSize)
        nameErrorLabel.textColor = .systemRed
        nameErrorLabel.text = ""
        contentView.addSubview(nameErrorLabel)
        
        surnameErrorLabel.font = .systemFont(ofSize: Constants.errorLabelFontSize)
        surnameErrorLabel.textColor = .systemRed
        surnameErrorLabel.text = ""
        contentView.addSubview(surnameErrorLabel)
        
        dateErrorLabel.font = .systemFont(ofSize: Constants.errorLabelFontSize)
        dateErrorLabel.textColor = .systemRed
        dateErrorLabel.text = ""
        contentView.addSubview(dateErrorLabel)
        
        passwordErrorLabel.font = .systemFont(ofSize: Constants.errorLabelFontSize)
        passwordErrorLabel.textColor = .systemRed
        passwordErrorLabel.text = ""
        contentView.addSubview(passwordErrorLabel)
        
        confirmPasswordErrorLabel.font = .systemFont(ofSize: Constants.errorLabelFontSize)
        confirmPasswordErrorLabel.textColor = .systemRed
        confirmPasswordErrorLabel.text = ""
        contentView.addSubview(confirmPasswordErrorLabel)
    }
}

// MARK: - Constraints
private extension RegistrationModuleView {
    func setupConstraints() {
        setupScrollViewConstraints()
        setupContentViewConstraints()
        setupNameTextFieldConstraints()
        setupNameErrorLabelConstraints()
        setupSurnameTextFieldConstraints()
        setupSurnameErrorLabelConstraints()
        setupDateTextFieldConstraints()
        setupDateErrorLabelConstraints()
        setupPasswordTextFieldConstraints()
        setupPasswordErrorLabelConstraints()
        setupConfirmPasswordTextFieldConstraints()
        setupConfirmPasswordErrorLabelConstraints()
        setupRegisterButtonConstraints()
    }
    
    func setupScrollViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupContentViewConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(scrollView.snp.height).offset(1)
        }
    }
    
    func setupNameTextFieldConstraints() {
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.fieldTopOffset)
            make.left.right.equalToSuperview().inset(Constants.fieldSideInset)
            make.height.equalTo(Constants.fieldHeight)
        }
    }
    
    func setupNameErrorLabelConstraints() {
        nameErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(Constants.errorLabelTopOffset)
            make.left.right.equalTo(nameTextField)
            make.height.equalTo(Constants.errorLabelHeight)
        }
    }
    
    func setupSurnameTextFieldConstraints() {
        surnameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameErrorLabel.snp.bottom).offset(Constants.fieldVerticalSpacing)
            make.left.right.equalToSuperview().inset(Constants.fieldSideInset)
            make.height.equalTo(Constants.fieldHeight)
        }
    }
    
    func setupSurnameErrorLabelConstraints() {
        surnameErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(surnameTextField.snp.bottom).offset(Constants.errorLabelTopOffset)
            make.left.right.equalTo(surnameTextField)
            make.height.equalTo(Constants.errorLabelHeight)
        }
    }
    
    func setupDateTextFieldConstraints() {
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(surnameErrorLabel.snp.bottom).offset(Constants.fieldVerticalSpacing)
            make.left.right.equalToSuperview().inset(Constants.fieldSideInset)
            make.height.equalTo(Constants.fieldHeight)
        }
    }
    
    func setupDateErrorLabelConstraints() {
        dateErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(Constants.errorLabelTopOffset)
            make.left.right.equalTo(dateTextField)
            make.height.equalTo(Constants.errorLabelHeight)
        }
    }
    
    func setupPasswordTextFieldConstraints() {
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(dateErrorLabel.snp.bottom).offset(Constants.fieldVerticalSpacing)
            make.left.right.equalToSuperview().inset(Constants.fieldSideInset)
            make.height.equalTo(Constants.fieldHeight)
        }
    }
    
    func setupPasswordErrorLabelConstraints() {
        passwordErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constants.errorLabelTopOffset)
            make.left.right.equalTo(passwordTextField)
            make.height.equalTo(Constants.errorLabelHeight)
        }
    }
    
    func setupConfirmPasswordTextFieldConstraints() {
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordErrorLabel.snp.bottom).offset(Constants.fieldVerticalSpacing)
            make.left.right.equalToSuperview().inset(Constants.fieldSideInset)
            make.height.equalTo(Constants.fieldHeight)
        }
    }
    
    func setupConfirmPasswordErrorLabelConstraints() {
        confirmPasswordErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(Constants.errorLabelTopOffset)
            make.left.right.equalTo(confirmPasswordTextField)
            make.height.equalTo(Constants.errorLabelHeight)
        }
    }
    
    func setupRegisterButtonConstraints() {
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordErrorLabel.snp.bottom).offset(Constants.buttonTopOffset)
            make.left.right.equalToSuperview().inset(Constants.fieldSideInset)
            make.height.equalTo(Constants.buttonHeight)
        }
    }
}

// MARK: - NavigationBar
private extension RegistrationModuleView {
    func setupNavigationBar() {
        self.title = Constants.navTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}

// MARK: - Keyboard
private extension RegistrationModuleView {
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(from notification: Notification) -> CGFloat? {
        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height
    }
}

// MARK: - Actions
private extension RegistrationModuleView {
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardHeight = getKeyboardHeight(from: notification) else { return }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        dateTextField.text = formatter.string(from: datePicker.date)
        updateRegisterButtonState()
    }
    
    @objc func togglePasswordVisibility() {
        setPasswordVisibility(for: passwordTextField, isVisible: &isPasswordVisible)
    }
    
    @objc func toggleConfirmPasswordVisibility() {
        setPasswordVisibility(for: confirmPasswordTextField, isVisible: &isConfirmPasswordVisible)
    }
    
    private func setPasswordVisibility(for textField: UITextField, isVisible: inout Bool) {
        isVisible.toggle()
        textField.isSecureTextEntry = !isVisible
        let imageName = isVisible ? "eye.slash" : "eye"
        if let button = textField.rightView as? UIButton {
            button.setImage(UIImage(systemName: imageName), for: .normal)
            button.tintColor = .black
        }
    }
    
    @objc func textFieldDidChange() {
        updateRegisterButtonState()
    }

    @objc func registrationButtonTapped() {
        presenter?.didTapRegistrationButton(name: nameTextField.text!, surname: surnameTextField.text!, date: dateTextField.text!, password: passwordTextField.text!, confirmPassword: confirmPasswordTextField.text!)
    }
}

// MARK: - Register Button State
private extension RegistrationModuleView {
    func updateRegisterButtonState() {
        let isAllFieldsFilled = !(nameTextField.text ?? "").isEmpty &&
                                !(surnameTextField.text ?? "").isEmpty &&
                                !(dateTextField.text ?? "").isEmpty &&
                                !(passwordTextField.text ?? "").isEmpty &&
                                !(confirmPasswordTextField.text ?? "").isEmpty
        registerButton.isEnabled = isAllFieldsFilled
        registerButton.backgroundColor = isAllFieldsFilled ? .black : .systemGray
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationModuleView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === dateTextField {
            textField.tintColor = .clear
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === dateTextField {
            return false
        }
        return true
    }
}

// MARK: - Helpers
private extension RegistrationModuleView {
    func addPasswordToggle(to textField: UITextField, selector: Selector) {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: selector, for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
    }
}

// MARK: - RegistrationModuleViewPresenterInput
extension RegistrationModuleView: RegistrationModuleViewPresenterInput {
    func showNameError(error: String) {
        nameErrorLabel.text = error
    }
    
    func showSurnameError(error: String) {
        surnameErrorLabel.text = error
    }
    
    func showDateError(error: String) {
        dateErrorLabel.text = error
    }
    
    func showPasswordError(error: String) {
        passwordErrorLabel.text = error
    }
    
    func showConfirmPasswordError(error: String) {
        confirmPasswordErrorLabel.text = error
    }
    
    func navigateToMainModule(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
