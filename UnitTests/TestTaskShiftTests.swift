//
//  TestTaskShiftTests.swift
//  TestTaskShiftTests
//
//  Created by Кирилл Софрин on 07.07.2025.
//

import XCTest
@testable import TestTaskShift

final class TestTaskShiftTests: XCTestCase {
    var validationManager: ValidationManager!
    var dataManager: DataManager!
    var networkManager: NetworkManager!

    override func setUpWithError() throws {
        validationManager = ValidationManager()
        dataManager = DataManager()
        networkManager = NetworkManager()
    }

    override func tearDownWithError() throws {
        validationManager = nil
        dataManager = nil
        networkManager = nil
        UserDefaults.standard.removeObject(forKey: "userName")
    }

    // MARK: - ValidationManager Tests
    func testAllFieldsValid() {
        let expectation = XCTestExpectation(description: "Все поля валидные")
        validationManager.validateRegistrationFields(
            name: "Иван",
            surname: "Иванов", 
            date: "01.01.1990",
            password: "password123",
            confirmPassword: "password123"
        ) { errors in
            XCTAssertTrue(errors.isEmpty, "Не должно быть ошибок для валидных данных")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInvalidNameTooShort() {
        let expectation = XCTestExpectation(description: "Ошибка для короткого имени")
        validationManager.validateRegistrationFields(
            name: "А",
            surname: "Иванов",
            date: "01.01.1990", 
            password: "password123",
            confirmPassword: "password123"
        ) { errors in
            XCTAssertTrue(errors.contains(.invalidName), "Должна быть ошибка для короткого имени")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInvalidNameWithNumbers() {
        let expectation = XCTestExpectation(description: "Ошибка для имени с цифрами")
        validationManager.validateRegistrationFields(
            name: "Иван123",
            surname: "Иванов",
            date: "01.01.1990",
            password: "password123", 
            confirmPassword: "password123"
        ) { errors in
            XCTAssertTrue(errors.contains(.invalidName), "Должна быть ошибка для имени с цифрами")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPasswordTooShort() {
        let expectation = XCTestExpectation(description: "Ошибка для короткого пароля")
        validationManager.validateRegistrationFields(
            name: "Иван",
            surname: "Иванов", 
            date: "01.01.1990",
            password: "pass1",
            confirmPassword: "pass1"
        ) { errors in
            XCTAssertTrue(errors.contains(.passwordTooShort), "Должна быть ошибка для короткого пароля")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPasswordWithoutNumbers() {
        let expectation = XCTestExpectation(description: "Ошибка для пароля без цифр")
        validationManager.validateRegistrationFields(
            name: "Иван",
            surname: "Иванов",
            date: "01.01.1990", 
            password: "password",
            confirmPassword: "password"
        ) { errors in
            XCTAssertTrue(errors.contains(.passwordNoNumber), "Должна быть ошибка для пароля без цифр")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPasswordWithoutLetters() {
        let expectation = XCTestExpectation(description: "Ошибка для пароля без букв")
        validationManager.validateRegistrationFields(
            name: "Иван",
            surname: "Иванов",
            date: "01.01.1990",
            password: "12345678",
            confirmPassword: "12345678"
        ) { errors in
            XCTAssertTrue(errors.contains(.passwordNoLetter), "Должна быть ошибка для пароля без букв")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPasswordsDontMatch() {
        let expectation = XCTestExpectation(description: "Ошибка для несовпадающих паролей")
        validationManager.validateRegistrationFields(
            name: "Иван",
            surname: "Иванов",
            date: "01.01.1990",
            password: "password123",
            confirmPassword: "password456"
        ) { errors in
            XCTAssertTrue(errors.contains(.passwordsDontMatch), "Должна быть ошибка для несовпадающих паролей")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMultipleErrors() {
        let expectation = XCTestExpectation(description: "Множественные ошибки валидации")
        validationManager.validateRegistrationFields(
            name: "А",
            surname: "Иванов",
            date: "01.01.1990",
            password: "123",
            confirmPassword: "456"
        ) { errors in
            XCTAssertTrue(errors.contains(.invalidName), "Должна быть ошибка имени")
            XCTAssertTrue(errors.contains(.passwordTooShort), "Должна быть ошибка короткого пароля")
            XCTAssertTrue(errors.contains(.passwordNoLetter), "Должна быть ошибка отсутствия букв")
            XCTAssertTrue(errors.contains(.passwordsDontMatch), "Должна быть ошибка несовпадения паролей")
            XCTAssertTrue(errors.count == 4, "Должно быть 4 ошибки")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - DataManager Tests
    func testSaveAndFetchUserSession() {
        let expectation = XCTestExpectation(description: "fetchUserSession возвращает сохраненное имя")
        let testUserName = "Тест"
        dataManager.saveUserSession(userName: testUserName)
        dataManager.fetchUserSession { userName in
            XCTAssertEqual(userName, testUserName, "Должно вернуть сохраненное имя пользователя")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchEmptyUserSession() {
        let expectation = XCTestExpectation(description: "fetchUserSession возвращает nil для пустой сессии")
        dataManager.fetchUserSession { userName in
            XCTAssertNil(userName, "Должно вернуть nil для пустой сессии")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteUserSession() {
        let expectation = XCTestExpectation(description: "fetchUserSession возвращает nil после удаления")
        let testUserName = "Тест"
        dataManager.saveUserSession(userName: testUserName)
        dataManager.deleteUserSession()
        dataManager.fetchUserSession { userName in
            XCTAssertNil(userName, "Должно вернуть nil после удаления сессии")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchUserName() {
        let expectation = XCTestExpectation(description: "fetchUserName возвращает сохраненное имя")
        let testUserName = "Тест"
        dataManager.saveUserSession(userName: testUserName)
        dataManager.fetchUserName { userName in
            XCTAssertEqual(userName, testUserName, "fetchUserName должен вернуть сохраненное имя")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - NetworkManager Tests
    func testFetchDataFromServer() {
        let expectation = XCTestExpectation(description: "fetchDataFromServer возвращает книги")
        networkManager.fetchDataFromServer { result in
            switch result {
            case .success(let books):
                XCTAssertNotNil(books, "Должен вернуться объект Books")
                XCTAssertNotNil(books.data, "Должен быть массив книг")
                XCTAssertTrue(books.data.count > 0, "Должно быть хотя бы одна книга")
                XCTAssertNotNil(books.data.first?.title, "Книга должна иметь название")
                XCTAssertNotNil(books.data.first?.author, "Книга должна иметь автора")
            case .failure(let error):
                XCTFail("Не должно быть ошибки: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
