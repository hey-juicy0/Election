//
//  GenderViewController.swift
//  Election
//
//  Created by Jeewoo Yim on 10/11/24.
//

import UIKit
struct Research{
    var gender:String?
    var birthYear:Int?
    var MNA:Int?
    var PR:Int?
    var color:String?
}
class GenderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func femalePressed(_ sender: UIButton) {
        let research = Research(gender: "female")
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BirthViewController") as? BirthViewController else { return }
        viewController.research = research
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func malePressed(_ sender: UIButton) {
        let research = Research(gender: "male")
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BirthViewController") as? BirthViewController else { return }
        viewController.research = research
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    

}
