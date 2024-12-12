//
//  PlaceViewController.swift
//  Election
//
//  Created by Jeewoo Yim on 10/11/24.
//

import UIKit

class PlaceViewController: UIViewController {
    
    let placeCode = UserDefaults.standard.string(forKey: "placeCode")
    let placeAuth = UserDefaults.standard.string(forKey: "placeAuth")
    let placeMember = UserDefaults.standard.string(forKey: "placeMember")

    @IBOutlet weak var currentField: UITextField!
    @IBOutlet weak var managerField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var currentUpdate: UILabel!
    @IBOutlet weak var codeStack: UIStackView!
    @IBOutlet weak var currentStack: UIStackView!
    @IBOutlet weak var managerStack: UIStackView!
    @IBOutlet weak var totalChangeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        managerStack.layer.masksToBounds = true
        managerStack.layer.cornerRadius = 10
        codeStack.layer.masksToBounds = true
        codeStack.layer.cornerRadius = 10
        currentStack.layer.masksToBounds = true
        currentStack.layer.cornerRadius = 10
        
        
        
        if placeCode != nil && placeAuth != nil && placeMember != nil{
            codeField.text = placeCode
            managerField.text = placeAuth
            currentField.text = placeMember
            codeField.isEnabled = false
            managerField.isEnabled = false
            currentField.isEnabled = false
            
            codeStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stackTouched)))
            managerStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stackTouched)))
            currentStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stackTouched)))
        }
        else{
            totalChangeButton.layer.masksToBounds = true
            totalChangeButton.layer.cornerRadius = 10
            totalChangeButton.isHidden = false
        }
    }
    
    @objc func stackTouched(_ sender: UITapGestureRecognizer) {
        guard let stackView = sender.view as? UIStackView else { return }
        
        switch stackView {
        case codeStack:
            showAlert(message: "수정이 필요하신가요?", textfield: codeField)
        case managerStack:
            showAlert(message: "수정이 필요하신가요?", textfield: managerField)
        case currentStack:
            showAlert(message: "수정이 필요하신가요?", textfield: currentField)
        default:
            break
        }
    }
    @IBAction func codePressed(_ sender: UIButton) {
        let code = Int(codeField.text!)
        UserDefaults.standard.setValue(code, forKey: "placeCode")
    }
    @IBAction func authPressed(_ sender: UIButton) {
        let auth = managerField.text
        UserDefaults.standard.setValue(auth, forKey: "placeAuth")
    }
    @IBAction func currentPressed(_ sender: UIButton) {
        let member = currentField.text
        UserDefaults.standard.setValue(member, forKey: "placeMember")
    }
    @IBAction func totalChange(_ sender: UIButton) {
        let code = Int(codeField.text!)
        UserDefaults.standard.setValue(code, forKey: "placeCode")
        let auth = managerField.text
        UserDefaults.standard.setValue(auth, forKey: "placeAuth")
        let member = currentField.text
        UserDefaults.standard.setValue(member, forKey: "placeMember")
    }
    

    @IBAction func uploadPressed(_ sender: UIButton) {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let fileName = "가회동주민센터_\(currentHour).json"
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) else {
            print("저장할 URL을 생성할 수 없습니다.")
            return
        }
        guard let jsonData = try? Data(contentsOf: url) else {
            print("JSON 파일을 읽을 수 없습니다.")
            return
        }

        guard let serverUrl = URL(string: "http://localhost:3000/upload") else {
            print("서버 URL을 생성할 수 없습니다.")
            return
        }

        var request = URLRequest(url: serverUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("에러 발생: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("서버 응답 오류")
                return
            }
            print("데이터 업로드 성공!")
        }
        task.resume()
        
    }
    
    func showAlert(message: String, textfield: UITextField) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "네", style: .destructive) { _ in
            if textfield == self.currentField{
                textfield.isEnabled = true
            }
            else{
                self.showModal()
            }
        }
        let noAction = UIAlertAction(title: "아니오", style: .default) { _ in
            return
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = scene.windows.first?.rootViewController {
                rootViewController.present(alert, animated: true)
            }
    }
    
    @objc func showModal() {
        let signVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController")
        signVC.modalPresentationStyle = .popover
        present(signVC, animated: true, completion: nil)
    }

}
