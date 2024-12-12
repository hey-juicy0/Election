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
}
class GenderViewController: UIViewController {
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        femaleButton.layer.masksToBounds = true
        femaleButton.layer.cornerRadius = 30
        maleButton.layer.masksToBounds = true
        maleButton.layer.cornerRadius = 30
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "뒤로"

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
