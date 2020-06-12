//
//  SignUpViewController.swift
//  IssueTracker
//
//  Created by TTOzzi on 2020/06/11.
//  Copyright © 2020 신한섭. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var userNameInputView: InputStackView!
    @IBOutlet weak var passwordInputView: InputStackView!
    @IBOutlet weak var confirmPasswordInputView: InputStackView!
    @IBOutlet weak var createAccountButton: BorderButton!
    
    // MARK: - Properties
    static let identifier: String = "signUp"
    private var signUpViewModel: SignUpViewModel?
    var successHandler: () -> () = {}
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: - Methods
    // MARK: SetUp
    private func setUp() {
        setUpSignUpViewModel()
        setUpUserNameInputView()
        setUpPasswordInputView()
        setUpConfirmPasswordInputView()
        setUpCreateButton()
    }
    
    private func setUpSignUpViewModel() {
        signUpViewModel = SignUpViewModel()
        userNameInputView.bind { [unowned self] userName in
            self.signUpViewModel?.signUpInfo.userName = userName
        }
        passwordInputView.bind { [unowned self] password in
            self.signUpViewModel?.signUpInfo.password = password
        }
        confirmPasswordInputView.bind { [unowned self] confirmPassword in
            self.signUpViewModel?.signUpInfo.confirmPassword = confirmPassword
        }
    }
    
    private func setUpUserNameInputView() {
        signUpViewModel?.isUserNameValid.bind { [unowned self] isValid in
            guard let isValid = isValid else { return }
            self.userNameInputView.textFieldBorderColor = isValid ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
        }
    }
    
    private func setUpPasswordInputView() {
        signUpViewModel?.isPasswordValid.bind { [unowned self] isValid in
            guard let isValid = isValid else { return }
            self.passwordInputView.textFieldBorderColor = isValid ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
        }
    }
    
    private func setUpConfirmPasswordInputView() {
        signUpViewModel?.isConfirmPasswordValid.bind { [unowned self] isValid in
            guard let isValid = isValid else { return }
            self.confirmPasswordInputView.textFieldBorderColor = isValid ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
        }
    }
    
    private func setUpCreateButton() {
        signUpViewModel?.isEnabled.bind { [unowned self] isEnabled in
            self.createAccountButton.isEnabled = isEnabled
            UIView.animate(withDuration: 0.5, animations: {
                self.createAccountButton.alpha = isEnabled ? 1 : 0.5
            })
        }
        signUpViewModel?.isEnabled.fire()
    }
    
    private func success(_ status: Bool) {
        if status {
            dismiss(animated: true) { self.successHandler() }
        } else {
            let alert = UIAlertController.alert(title: "에러 발생", message: "중복된 아이디입니다.", actions: ["닫기": .none])
            present(alert, animated: true)
        }
    }
    
    // MARK: - IBActions
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        SignUpUseCase().createAccount(networkManager: NetworkManager(),
                                      userName: signUpViewModel?.signUpInfo.userName,
                                      password: signUpViewModel?.signUpInfo.password,
                                      successHandler: { model in
                                        self.success(model.status) },
                                      failHandler: { error in
                                        let alert = UIAlertController.alert(title: "에러 발생", message: error.localizedDescription, actions: ["닫기": .none])
                                        self.present(alert, animated: true)
        })
    }
}


