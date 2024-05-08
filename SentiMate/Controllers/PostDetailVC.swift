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
    
    var documentID: String?
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
            
            cell.setDate(selectedDate ?? Date())
            
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
            
            cell.setCategoryIndex(selectedCategoryIndex)
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "textfield", for: indexPath) as? TextFieldCell else {
                fatalError("Could not dequeue TextFieldCell")
            }
            
            cell.textField.text = userInput
            
            cell.onSave = { [weak self] in
                self?.userInput = cell.textField.text
                let userUID = Auth.auth().currentUser?.uid ?? "Unknown UID"
                var newEntry: [String: Any] = [
                    "userID": userUID,
                    "customTime": self?.dateFormatter.string(from: self?.selectedDate ?? .now),
                    "emotion": self?.emotion,
                    "category": self?.selectedCategoryIndex,
                    "content": self?.userInput
                ]
                
                if let docID = self?.documentID {
                    newEntry["documentID"] = docID
                }
                
                
                if let lastDiary = DiaryManager.shared.lastDiaryWithEmotion(self?.emotion ?? "") {
                    guard let mandarinEmotion = self?.textForEmotion(lastDiary.emotion) else { return }
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 8
                    paragraphStyle.alignment = .center
                    
                    let attributes = NSAttributedString(string: "\(lastDiary.content)",
                                                        attributes: [NSAttributedString.Key.paragraphStyle:
                                                                        paragraphStyle])
                    
                    DispatchQueue.main.async {
                        AlertView.instance.showAlert(
                            image: lastDiary.emotion,
                            title: "上次感到\(mandarinEmotion)是因為「\(buttonTitles[lastDiary.category])」",
                            message: attributes,
                            alertType: .reminder)
                        
                        self?.saveDiaryEntry(newEntry: newEntry)
                    }
                } else {
                    self?.saveDiaryEntry(newEntry: newEntry)
                }
            }
            return cell
        }
    }
}

extension PostDetailVC {
    func saveDiaryEntry(newEntry: [String: Any]) {
        if let documentID = newEntry["documentID"] as? String {
            FirebaseManager.shared.updateData(to: "diaries", documentID: documentID , data: newEntry) { result in
                self.handleSaveResult(result)
            }
        } else {
            FirebaseManager.shared.saveData(to: "diaries", data: newEntry) { result in
                self.handleSaveResult(result)
            }
        }
    }
    
    private func handleSaveResult(_ result: Result<Void, Error>) {
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
