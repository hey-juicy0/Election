//
//  MainViewController.swift
//  Election
//
//  Created by Jeewoo Yim on 10/6/24.
//

import UIKit

class MainViewController: UIViewController {
    
    var fiveCount = 0
    var totalCount = 0
    var researchCount = 0
    var originalColor: UIColor?
    var isResearched = false
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var researchLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var researchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLabel.text = String(fiveCount)
        totalLabel.text = String(totalCount)
        researchLabel.text = String(researchCount)
        originalColor = researchButton.backgroundColor

        // 모서리 둥글게 설정
        totalLabel.layer.cornerRadius = 10
        totalLabel.layer.masksToBounds = true
        researchLabel.layer.cornerRadius = 10
        researchLabel.layer.masksToBounds = true
        currentLabel.layer.cornerRadius = 20
        currentLabel.layer.masksToBounds = true
        researchButton.layer.masksToBounds = true
        researchButton.layer.cornerRadius = 30
        
    }

    @IBAction func longPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let alert = UIAlertController(title: nil, message: "설정으로 이동하시겠습니까?", preferredStyle: .alert)

            let yesAction = UIAlertAction(title: "네", style: .destructive) { _ in
                guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PlaceViewController") else { return }
                self.navigationController?.pushViewController(viewController, animated: true)
            }

            let noAction = UIAlertAction(title: "아니오", style: .default, handler: nil)

            alert.addAction(yesAction)
            alert.addAction(noAction)

            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func plusButton(_ sender: UIButton) {
        if fiveCount >= 4{
            if isResearched{
                fiveCount = 1
                isResearched = false
            }
            else{
                showAlert(message: "조사를 완료하세요.")
            }
        }
        else {
            fiveCount += 1
            totalCount += 1
            if fiveCount == 4{
                itsFour()
                
            }
        }
        currentLabel.text = String(fiveCount)
        totalLabel.text = String(totalCount)
    }
    
    @IBAction func minusButton(_ sender: UIButton) {
        if fiveCount <= 0 {
            fiveCount = 0
        } else {
            fiveCount -= 1
            totalCount -= 1
        }
        currentLabel.text = String(fiveCount) // 현재 카운트 업데이트
        totalLabel.text = String(totalCount)
    }
    
    @IBAction func goResearch(_ sender: UIButton) {

        
        fiveCount  += 1
        totalCount += 1
        currentLabel.text = String(fiveCount) // 현재 카운트 업데이트
        totalLabel.text = String(totalCount)

        researchButton.backgroundColor = originalColor

        researchCount += 1
        researchLabel.text = String(researchCount)
        isResearched = true
        

        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "GenderViewController") else{return}
        fiveCount = 0
        currentLabel.text = String(fiveCount)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func itsFour() {
        showAlert(message: "다음 사람을 조사하세요!")
        researchButton.isEnabled = true
        researchButton.backgroundColor = .systemBlue
        researchButton.tintColor = .white

    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
