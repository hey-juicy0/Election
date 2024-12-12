//
//  SignInViewController.swift
//  Election
//
//  Created by Jeewoo Yim on 11/1/24.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    var phoneNum = UserDefaults.standard.value(forKey: "phoneNum")
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func sendNumber(_ sender: UIButton) {
        guard let phoneNumber = phoneField.text, !phoneNumber.isEmpty else {
            showAlert(message: "휴대폰 번호를 입력해주세요.")
            return
        }
        
        let formattedPhoneNumber = formatPhoneNumber(phoneNumber)
        print("Formatted Phone Number: \(formattedPhoneNumber)")
        
        Auth.auth().languageCode = "kr"
        PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                self.showAlert(message: "인증번호 전송 도중 오류가 발생했습니다: \(error.localizedDescription)")
                return
            }
            
            guard let verificationID = verificationID else {
                self.showAlert(message: "Verification ID가 nil입니다.")
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.showAlert(message: "인증번호가 전송되었습니다.")
        }
    }
    
    func formatPhoneNumber(_ phoneNumber: String) -> String {
        // 입력된 번호에서 숫자만 추출
        var cleanPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // 한국 번호에 대한 포맷팅
        if cleanPhoneNumber.hasPrefix("010")
        {
            cleanPhoneNumber.removeFirst()
            return "+82\(cleanPhoneNumber)"
        }
        
        // 기본 포맷팅
        return "+82\(cleanPhoneNumber)"
    }
    @IBAction func confirmButton(_ sender: UIButton) {
        guard let verificationCode = confirmField.text, !verificationCode.isEmpty,
              let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            showAlert(message: "인증번호를 입력해주세요.")
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                self.showAlert(message: "인증번호 확인 도중 오류가 발생했습니다: \(error.localizedDescription)")
                return
            }
            
            if let phoneNumber = self.phoneField.text {
                self.phoneNum = phoneNumber
            }
            
            self.showAlert(message: "인증되었습니다.")
            
            
        }
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
