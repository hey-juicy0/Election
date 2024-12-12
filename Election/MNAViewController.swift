//
//  MNAViewController.swift
//  Election
//
//  Created by Jeewoo Yim on 10/11/24.
//

import UIKit


struct MNAStruct: Decodable {
    let number: Int
    let name: String
    let party: String
    let color: String
}

class MNAViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var Mna: [MNAStruct] = []
    var research: Research?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "뒤로"
        tableView.dataSource = self
        tableView.delegate = self
        

        if let load = loadJSON() {
            Mna = load
        }
        
        tableView.reloadData()
    }

    func loadJSON() -> [MNAStruct]? {
        guard let url = Bundle.main.url(forResource: "mna", withExtension: "json") else {
            print("JSON 파일을 찾을 수 없습니다.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode([MNAStruct].self, from: data)
            return decodedData
        } catch {
            print("JSON 디코딩 에러: \(error)")
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Mna.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MNATableCell", for: indexPath) as? MNATableCell else {
            return UITableViewCell()
        }

        let candidate = Mna[indexPath.row]
        cell.numberLabel.text = String(candidate.number)
        cell.nameLabel.text = candidate.name
        cell.partyLabel.text = candidate.party
        cell.backgroundColor = UIColor(hexCode: candidate.color)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = Mna[indexPath.row].number
        research?.MNA = selected

        let alertController = UIAlertController(title: nil, message: "기호 \(Mna[indexPath.row].number)번 \(Mna[indexPath.row].party) \(Mna[indexPath.row].name)을 투표하셨나요?", preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "네", style: .default) { _ in
            guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PRViewController") as? PRViewController else { return }
            viewController.research = self.research
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel) { _ in
            tableView.deselectRow(at: indexPath, animated: true)
        }
        

        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        present(alertController, animated: true, completion: nil)

        tableView.deselectRow(at: indexPath, animated: true)
    }

}

class MNATableCell: UITableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
