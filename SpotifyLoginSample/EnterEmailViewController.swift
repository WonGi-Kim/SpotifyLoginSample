//
//  EnterEmailViewController.swift
//  SpotifyLoginSample
//
//  Created by 김원기 on 2022/09/05.
//

import UIKit
import FirebaseAuth
import Firebase

class EnterEmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 30
        
        // 이메일과 패스워드가 채워지지 않았을때 다음버튼 비활성화
        nextButton.isEnabled = false
        
        // firebase 인증에 값을 전달할 textfield 의 값을 받으려면 textfield delegate 설정이 필요하다.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // 첫 화면에 들어서면 이메일 텍스트필드에 커서가 바로 위치하도록
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation bar 보이기
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .tintColor
        self.navigationController?.navigationBar.isTranslucent = false

    }
    
    @IBAction func tapNextButton(_ sender: UIButton) {
        // 이메일과 패스워드가 채워지지 않았을때 다음버튼 비활성화
        // 모든 필드가 입력되어서 다음 버튼이 눌러질 때 firebase 인증
        // 비어있다면 비어있는 값으로 옵셔널 처리
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // 신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: // 이미 가입한 계정일 때
                    self.loginUser(withEmail: email, password: password)//로그인 하기
                default:
                    self.errorLabel.text = error.localizedDescription
                }
    
            } else {
                self.showMainViewController()
            }
        }
    }
    
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorLabel.text = error.localizedDescription
            } else {
                self.showMainViewController()
            }
        }
    }
    
    // 계정 생성에 성공했다면 MainViewController 로 이동하는 코드
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.show(mainViewController, sender: nil)
        //self.navigationController?.pushViewController(mainViewController, animated: true)
        
    }
    
}


// delegate 설정
extension EnterEmailViewController: UITextFieldDelegate {
    // 키보드 입력이 끝나고 리턴 버튼이 눌렸을 때 키보드 내려가게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // 이메일 비밀번호 입력값이 있는지 확인해서 다음 버튼 활성화
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = self.emailTextField.text == ""
        let isPasswordEmpty = self.passwordTextField.text == ""
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
        //self.nextButton.isEnabled = !(self.emailTextField.text?.isEmpty ?? true) && !(self.passwordTextField.text?.isEmpty ?? true)

        
    }
}
