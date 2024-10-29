//
//  PRViewController.swift
//  Election
//
//  Created by Jeewoo Yim on 10/11/24.
//

import UIKit

struct PRStruct:Decodable{
    let number: Int
    let party: String
    let color: String
}
class PRViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pr: [PRStruct] = []
    var research: Research?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        if let load = loadJSON() {
            pr = load
        }
        
        tableView.reloadData()
    }
    
    func loadJSON() -> [PRStruct]? {
        guard let url = Bundle.main.url(forResource: "pr", withExtension: "json") else {
            print("JSON 파일을 찾을 수 없습니다.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode([PRStruct].self, from: data)
            return decodedData
        } catch {
            print("JSON 디코딩 에러: \(error)")
            return nil
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PRTableCell", for: indexPath) as? PRTableCell else {
            return UITableViewCell()
        }

        let candidate = pr[indexPath.row]
        cell.numberLabel.text = String(candidate.number)
        cell.partyLabel.text = candidate.party
        cell.backgroundColor = UIColor(hexCode: candidate.color)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = pr[indexPath.row].number
        research?.PR = selected

        let alertController = UIAlertController(title: nil, message: "기호 \(pr[indexPath.row].number)번 \(pr[indexPath.row].party)을 투표하셨나요?", preferredStyle: .alert)

        
        let yesAction = UIAlertAction(title: "네", style: .default) { _ in
            self.saveResearchData()
            self.showAlert(message: "응답해주셔서 감사합니다. \n 좋은 하루 보내세요!")
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in
            tableView.deselectRow(at: indexPath, animated: true)
        }
        

        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        present(alertController, animated: true, completion: nil)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func saveResearchData() {
        guard let research = research else { return }
        let currentHour = Calendar.current.component(.hour, from: Date())
        let fileName = "가회동주민센터_\(currentHour).json"
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) else {
            print("저장할 URL을 생성할 수 없습니다.")
            return
        }
        
        var existingData: [[String: Any]] = []
        if let data = try? Data(contentsOf: url) {
            if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                existingData = jsonArray
            }
        }
        
        let newData: [String: Any] = ["gender": research.gender!, "birthYear": research.birthYear!, "MNA": research.MNA!, "PR": research.PR!]
        existingData.append(newData)
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: existingData, options: .prettyPrinted) {
            do {
                try jsonData.write(to: url)
                print("성공!")
                self.navigationController?.popToRootViewController(animated: true)
            } catch {
                print("데이터 저장 에러: \(error)")
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pr.count
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

class PRTableCell: UITableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
}
