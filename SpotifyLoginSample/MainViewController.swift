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
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = """
        환영합니다.
        \(email)님
        """
        
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
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
        
        // alert 으로 확인
        let alert = UIAlertController(title: "비밀번호 초기화", message: "메일을 확인하세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
