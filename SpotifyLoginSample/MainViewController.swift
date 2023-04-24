//
//  MainViewController.swift
//  SpotifyLoginSample
//
//  Created by 김원기 on 2022/09/07.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var passwordResetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 메인 뷰 컨트롤러에서 이동이 일어날 경우 UI 가 어색해질 수 있음
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.gray.cgColor
        logoutButton.layer.cornerRadius = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        // 현재 로그인된 사용자 이메일 표시
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = """
        환영합니다.
        \(email)님
        """
        
        // 이메일 패스워드를 통해 로그인 한 경우에만 비밀번호 초기화 버튼 표시
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        passwordResetButton.isHidden = !isEmailSignIn
    }
    
    @IBAction func tapLogoutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            // 첫번째 화면으로 이동
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
    }
    
    @IBAction func tapPasswordResetButton(_ sender: UIButton) {
        // 현재 로그인 된 사용자의 이메일로 비밀번호 초기화 이메일 전송
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
        
        // alert 으로 확인
        let alert = UIAlertController(title: "비밀번호 초기화", message: "메일을 확인하세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
