//
//  BirthViewController.swift
//  Election
//
//  Created by Jeewoo Yim on 10/11/24.
//

import UIKit

class BirthViewController: UIViewController {
    @IBOutlet weak var stack: UIStackView!
    var research: Research?
    
    @IBOutlet weak var birthTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stack.layer.masksToBounds = true
        stack.layer.cornerRadius = 30

    }
    @IBAction func birthPressed(_ sender: UIButton) {
        guard let birthYearText = birthTextField.text,
                  let birthYear = Int(birthYearText),
                  (1900...2006).contains(birthYear) else {
            showAlert(message: "올바른 연도를 입력하세요.")
            return }
        research?.birthYear = Int(birthYear)
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MNAViewController") as? MNAViewController else { return }
        viewController.research = research
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    


}
