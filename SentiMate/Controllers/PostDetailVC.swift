//
//  PostDetailVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import UIKit
import Lottie
import FirebaseAuth

class PostDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var emotion: String?
    
    var selectedDate: Date?
    var selectedCategoryIndex: Int?
    var userInput: String?
    let dateFormatter = DateFormatter()
    
    let musicManager = MusicManager()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        hideKeyboardWhenTappedAround()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: animated);
//        super.viewWillDisappear(animated)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
}

extension PostDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath) as? DateCell else {
                fatalError("Could not dequeue DateCell")
            }
            
            cell.onDateChanged = { [weak self] date in
                self?.selectedDate = date
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "emotion", for: indexPath) as? EmotionCell else {
                fatalError("Could not dequeue EmotionCell")
            }
            cell.configure(withEmotion: emotion ?? "")
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as? CategoryCell else {
                fatalError("Could not dequeue CategoryCell")
            }
            
            cell.onCategorySelected = { [weak self] index in
                self?.selectedCategoryIndex = index
                
                if let textFieldCell = tableView.cellForRow(at: IndexPath(row: 3, section: indexPath.section)) as? TextFieldCell {
                                textFieldCell.saveBtn.isEnabled = true
                            }
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "textfield", for: indexPath) as? TextFieldCell else {
                fatalError("Could not dequeue TextFieldCell")
            }
            
            cell.onSave = { [weak self] in
                self?.userInput = cell.textField.text
                let userUID = Auth.auth().currentUser?.uid ?? "Unknown UID"
                let newEntry: [String: Any] = [
                    "userID": userUID,
                    "customTime": self?.dateFormatter.string(from: self?.selectedDate ?? .now),
                    "emotion": self?.emotion,
                    "category": self?.selectedCategoryIndex,
                    "content": self?.userInput
                ]
                
                if let lastDiary = DiaryManager.shared.lastDiaryWithEmotion(self?.emotion ?? "") {
                        // Show an alert with the last diary's details
                    guard let mandarinEmotion = self?.textForEmotion(lastDiary.emotion) else { return }
                        DispatchQueue.main.async {
                            AlertView.instance.showAlert(
                                image: lastDiary.emotion,
                                title: "上一次感到\(mandarinEmotion)是因為\(buttonTitles[lastDiary.category])",
                                message: "\(lastDiary.content)",
                                alertType: .reminder)
                            
                                self?.saveDiaryEntry(newEntry: newEntry)
                        }
                    } else {
                        // If no previous entry, save directly
                        self?.saveDiaryEntry(newEntry: newEntry)
                    }
                }
            return cell
        }
    }
}

extension PostDetailVC {
    func saveDiaryEntry(newEntry: [String: Any]) {
        FirebaseManager.shared.saveData(to: "diaries", data: newEntry) { result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                print("Error saving data: \(error)")
            }
        }
    }
}

extension PostDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 73
        case 1:
            return 126
        case 2:
            return 200
        default:
            return 291
        }
    }
    
}

extension PostDetailVC {
    func textForEmotion(_ emotion: String) -> String {
            switch emotion {
            case "Surprise": return "驚喜"
            case "Happy": return "開心"
            case "Neutral": return "普通"
            case "Fear": return "緊張"
            case "Sad": return "難過"
            case "Angry": return "生氣"
            default: return "厭惡"
            }
        }
}
