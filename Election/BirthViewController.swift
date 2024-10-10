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
        let birthYear = Int(birthTextField.text ?? "1999")
        let user = Research(birthYear: birthYear)
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MNAViewController") as? MNAViewController else { return }
        viewController.research = research
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    


}
