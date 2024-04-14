//
//  PostDetailVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import UIKit
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
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "textfield", for: indexPath) as? TextFieldCell else {
                fatalError("Could not dequeue TextFieldCell")
            }
            
            cell.onSave = { [weak self] in
                self?.userInput = cell.textField.text
                
                let newEntry: [String: Any] = [
                    "userID": "kellyli",
                    "customTime": self?.dateFormatter.string(from: self?.selectedDate ?? .now),
                    "emotion": self?.emotion,
                    "category": self?.selectedCategoryIndex,
                    "content": self?.userInput
                ]
                
                FirebaseManager.shared.saveData(to: "diaries", data: newEntry) { result in
                    switch result {
                    case .success():
                        print("Data saved successfully")
                        self?.dismiss(animated: true, completion: nil)
                    case .failure(let error):
                        print("Error saving data: \(error)")
                    }
                }
            }
            
            return cell
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
            return 250
        default:
            return 291
        }
    }
    
}

