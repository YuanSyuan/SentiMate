//
//  HomeVC+Extension.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/5/16.
//

import UIKit

extension HomeVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension HomeVC {
    
    func configureContextMenu(for indexPath: IndexPath) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            let edit = UIAction(title: "編輯", image: UIImage(systemName: "square.and.pencil")) { _ in
                self.editDiaryEntry(at: indexPath)
            }
            
            let delete = UIAction(title: "刪除", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteDiaryEntry(at: indexPath)
            }
            return UIMenu(title: "Options", children: [edit, delete])
        }
    }
    
    func editDiaryEntry(at indexPath: IndexPath) {
        let diary = DiaryManager.shared.diaries[indexPath.row]
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detail") as? PostDetailVC {
            let viewModel = PostDetailViewModel(emotion: diary.emotion)
            viewController.viewModel = viewModel
            viewController.documentID = diary.documentID
            viewModel.emotion = diary.emotion
            viewModel.selectedDate = DateFormatter.diaryEntryFormatter.date(from: diary.customTime) ?? .now
            viewModel.userInput = diary.content
            navigationController?.pushViewController(viewController, animated: true)
            print(viewController.selectedDate)
        }
    }
    
    func deleteDiaryEntry(at indexPath: IndexPath) {
        let diary = DiaryManager.shared.diaries[indexPath.row]
        
        firebaseManager.deleteDiaryEntry(documentID: diary.documentID) { success, error in
            if success {
            } else if let error = error {
                print("Error deleting diary entry: \(error.localizedDescription)")
            }
        }
    }
}
