//
//  PlaceViewController.swift
//  Election
//
//  Created by Jeewoo Yim on 10/11/24.
//

import UIKit

class PlaceViewController: UIViewController {

    @IBOutlet weak var currentField: UITextField!
    @IBOutlet weak var managerField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var currentUpdate: UILabel!
    @IBOutlet weak var codeStack: UIStackView!
    @IBOutlet weak var currentStack: UIStackView!
    @IBOutlet weak var managerStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        managerStack.layer.masksToBounds = true
        managerStack.layer.cornerRadius = 10
        codeStack.layer.masksToBounds = true
        codeStack.layer.cornerRadius = 10
        currentStack.layer.masksToBounds = true
        currentStack.layer.cornerRadius = 10
    }
    

    @IBAction func uploadPressed(_ sender: UIButton) {
    }


}
