//
//  PostDetailVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import UIKit
import Lottie
import FirebaseAuth
import Combine

class PostDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var documentID: String?
    var viewModel: PostDetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    var emotion: String?
    var selectedDate: Date?
    var selectedCategoryIndex: Int?
    var userInput: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        bindViewModel()
        hideKeyboardWhenTappedAround()
    }
    
    private func bindViewModel() {
        viewModel.$selectedDate
            .sink { [weak self] date in
                if let cell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DateCell {
                    cell.setDate(date)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$emotion
            .sink { [weak self] emotion in
                if let cell = self?.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EmotionCell {
                    cell.configure(withEmotion: emotion)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$selectedCategoryIndex
            .sink { [weak self] index in
                if let cell = self?.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? CategoryCell {
                    cell.setCategoryIndex(index)
                }
            }
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
                self?.viewModel.selectedDate = date
            }
            
            cell.setDate(viewModel.selectedDate)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "emotion", for: indexPath) as? EmotionCell else {
                fatalError("Could not dequeue EmotionCell")
            }
            
            cell.configure(withEmotion: viewModel.emotion)
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as? CategoryCell else {
                fatalError("Could not dequeue CategoryCell")
            }
            
            cell.onCategorySelected = { [weak self] index in
                self?.viewModel.selectedCategoryIndex = index
                
                if let textFieldCell = tableView.cellForRow(at: IndexPath(row: 3, section: indexPath.section)) as? TextFieldCell {
                    textFieldCell.saveBtn.isEnabled = true
                }
            }
            
            cell.setCategoryIndex(viewModel.selectedCategoryIndex)
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "textfield", for: indexPath) as? TextFieldCell else {
                fatalError("Could not dequeue TextFieldCell")
            }
            
            cell.configure(withText: viewModel.userInput)
            
            cell.onSave = { [weak self] in
                self?.viewModel.userInput = cell.textField.text ?? ""
                self?.viewModel.saveDiaryEntry(documentID: self?.documentID){ result in
                    self?.handleSaveResult(result)
                }
            }
            
            return cell
        }
    }
}

extension PostDetailVC {
//    func saveDiaryEntry(newEntry: [String: Any]) {
//        if let documentID = newEntry["documentID"] as? String {
//            FirebaseManager.shared.updateData(to: "diaries", documentID: documentID , data: newEntry) { result in
//                self.handleSaveResult(result)
//            }
//        } else {
//            FirebaseManager.shared.saveData(to: "diaries", data: newEntry) { result in
//                self.handleSaveResult(result)
//            }
//        }
//    }
    
    private func handleSaveResult(_ result: Result<Void, Error>) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        switch result {
        case .success():
            DispatchQueue.main.async {
                self.showAlert()
                dispatchGroup.leave()
                dispatchGroup.notify(queue: .main) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        case .failure(let error):
            print("Error saving data: \(error)")
        }
    }
    
    private func showAlert() {
        if let lastDiary = DiaryManager.shared.lastDiaryWithEmotion(viewModel.emotion), let emotionEnum = Emotions(rawValue: lastDiary.emotion) {
            let mandarinEmotion = Emotions.getMandarinEmotion(emotion: emotionEnum)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
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
                
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
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

