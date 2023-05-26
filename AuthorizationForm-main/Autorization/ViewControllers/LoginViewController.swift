//
//  ViewController.swift
//  Autorization
//
//  Created by Ilya Derezovskiy on 26/5/23.
//  

import UIKit
import CryptoKit

class LoginViewController: UIViewController {
    var attempts = 0
    
    @IBOutlet var userNameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var answerText: UITextField!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBarController = segue.destination as? UITabBarController else { return }
        guard tabBarController.viewControllers != nil else { return }
        
        guard segue.destination is WelcomeViewController else {
            return
        }
        
    }
    
    // MARK: -  Действия при нажатии на кнопку сброса пароля
    @IBAction func forgotDataTapped() {
        if answerText.text!.count == 0 {
            showAlert(
                with: "Необходимо заполнить поле контрольного вопроса!",
                and: "Укажите имя домашнего питомца, который вы указали при регистрации"
            )
        } else if answerText.text == UserDefaults.standard.string(forKey: "answer") {
            if passwordText.text!.count < 8 {
                showAlert(
                    with: "Длина пароля не может быть менее 8 символов!",
                    and: ""
                )
            } else if checkTextSufficientComplexity(var: passwordText.text!) == false {
                showAlert(
                    with: "Пароль должен содержать заглавные и строчные буквы, цифры и специальные символы!",
                    and: "Например, oNQZnz$Hx2"
                )
            } else {
                showAlert(
                    with: "Пароль успешно изменён!",
                    and: "Новый пароль: \(passwordText.text!)"
                )
                
                let hashpassword = passwordHash(email: userNameText.text!, password: passwordText.text!)
                UserDefaults.standard.set(hashpassword, forKey: "password")
                
                UserDefaults.standard.set(userNameText.text, forKey: "username")
                
                attempts = 0
            }
        }
    }
    
    // MARK: -  Действия при нажатии на кнопку авторизации
    @IBAction func logInAction() {
        let hashpassword = passwordHash(email: userNameText.text!, password: passwordText.text!)
        if attempts == 3 && (hashpassword != UserDefaults.standard.string(forKey: "password") || userNameText.text != UserDefaults.standard.string(forKey: "username")) {
            showAlert(
                with: "Установлена задержка на 20 секунд!!",
                and: ""
            )
            sleep(20)
        } else if hashpassword != UserDefaults.standard.string(forKey: "password") || userNameText.text != UserDefaults.standard.string(forKey: "username") {
            showAlert(
                with: "Неверные имя пользователя и пароль!",
                and: "Пользователь с такими данными не найден"
            )
            attempts += 1
        } else {
            attempts = 0
        }
    }
    
    // MARK: -  Действия при нажатии на кнопку регистрации
    @IBAction func authInAction() {
        if userNameText.text!.count == 0 {
            showAlert(
                with: "Необходимо указать имя!", and: ""
            )
        } else if passwordText.text!.count < 8 {
            showAlert(
                with: "Длина пароля не может быть менее 8 символов!",
                and: ""
            )
        } else if checkTextSufficientComplexity(var: passwordText.text!) == false {
            showAlert(
                with: "Пароль должен содержать заглавные и строчные буквы, цифры и специальные символы!",
                and: "Например, oNQZnz$Hx2"
            )
        } else if answerText.text!.count == 0 {
            showAlert(
                with: "Необходимо заполнить поле контрольного вопроса!",
                and: "Запомните ответ, он пригодится, если забудете пароль"
            )
        } else {
            let hashpassword = passwordHash(email: userNameText.text!, password: passwordText.text!)
            print(hashpassword)
            UserDefaults.standard.set(hashpassword, forKey: "password")
            
            UserDefaults.standard.set(userNameText.text, forKey: "username")
            
            UserDefaults.standard.set(answerText.text, forKey: "answer")
        }
    }
    
    @IBAction func unwind(for segue: UIStoryboardSegue) {
//        userNameText.text = ""
//        passwordText.text = ""
    }
    
    // MARK: -  Проверка введённого пароля
    func checkTextSufficientComplexity(var text : String) -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        
        let lowerLetterRegEx  = ".*[a-z]+.*"
        let texttest3 = NSPredicate(format:"SELF MATCHES %@", lowerLetterRegEx)
        let lowerresult = texttest3.evaluate(with: text)

        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialresult = texttest2.evaluate(with: text)
        
        return capitalresult && lowerresult && numberresult && specialresult
    }
    
    // Хэширование пароля
    func passwordHash(email: String, password: String) -> String {
        let salt = "x4vV8bGgqqmQwgCoyXFQj+(o.nUNQhVP7ND"
        return SHA256.hash(data: Data("\(password).\(email).\(salt)".utf8)).description
    }
}

// MARK: - Расширение окна уведомления пользователя
extension LoginViewController {
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.passwordText.text = ""
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameText {
            passwordText.becomeFirstResponder()
        } else {
            logInAction()
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        
        return true
    }
    
}
