//
//  AnalyticsVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/10.
//
//
import UIKit
import SwiftUI
import Charts
import FirebaseStorage
import ViewAnimator
import Lottie

class AnalyticsVC: UIViewController {
    var firebaseManager = FirebaseManager.shared
    private var tableView: UITableView!
    private var hostingController: UIHostingController<DonutChartView>?
    var AIResponse: String?
    var isLoading = false
    private var loadingAnimationView: LottieAnimationView?
    private var latestDiaries: [Diary] {
        Array(DiaryManager.shared.diaries.prefix(7))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(diariesDidUpdate), name: NSNotification.Name("DiariesUpdated"), object: nil)
        
        firebaseManager.onNewData = { newDiaries in
            DiaryManager.shared.updateDiaries(newDiaries: newDiaries)
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tableView.reloadData()
//    }
    
    @objc private func diariesDidUpdate() {
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AICell.self, forCellReuseIdentifier: "AICell")
        tableView.register(ChartCell.self, forCellReuseIdentifier: "ChartCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.frameLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.backgroundColor = defaultBackgroundColor
    }
}

extension AnalyticsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AICell", for: indexPath) as? AICell else {
                fatalError("Could not dequeue AICell") }
            
            let emojis = latestDiaries.reversed().map { $0.emotion }
            cell.configure(with: emojis)
            
            cell.delegate = self
            
            if AIResponse != nil {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 8
                paragraphStyle.alignment = .left
                
                let attributes = NSAttributedString(string: AIResponse ?? "",
                                                    attributes: [NSAttributedString.Key.paragraphStyle:
                                                                    paragraphStyle])
                cell.AIResponseLbl.textAlignment = .left
                cell.AIResponseLbl.attributedText = attributes
            } else {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 8
                paragraphStyle.alignment = .center
                
                let newAttributes = NSAttributedString(string: "最近七筆日記裡面，情緒有些變動呢\n點擊下方按鈕查看AI分析吧！",
                                                       attributes: [NSAttributedString.Key.paragraphStyle:
                                                                        paragraphStyle])
                cell.AIResponseLbl.textAlignment = .center
                cell.AIResponseLbl.attributedText = newAttributes
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as? ChartCell else {
                fatalError("Could not dequeue ChartCell") }
            
            let emotionTypes = DiaryManager.shared.getEmotionTypes(forPeriod: .allTime)
            let swiftUIView = DonutChartView(emotionTypes: emotionTypes)
            // If we already have a hosting controller, just update the SwiftUI view
            
            // MARK: - original
//            if let hostingController = hostingController {
//                hostingController.rootView = swiftUIView
//            } else {
//                // Create the hosting controller with the SwiftUI view
//                let newHostingController = UIHostingController(rootView: swiftUIView)
//                addChild(newHostingController)
//                cell.contentView.addSubview(newHostingController.view)
//                newHostingController.view.translatesAutoresizingMaskIntoConstraints = false
//                
//                newHostingController.view.clipsToBounds = true
//                newHostingController.view.layer.cornerRadius = 20
//                
//                NSLayoutConstraint.activate([
//                    newHostingController.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 72),
//                    newHostingController.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
//                    newHostingController.view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
//                    newHostingController.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20)
//                ])
//                
//                newHostingController.didMove(toParent: self)
//                hostingController = newHostingController
//            }
            //MARK: - for demo
            if let existingHostingController = hostingController {
                    existingHostingController.willMove(toParent: nil)
                    existingHostingController.view.removeFromSuperview()
                    existingHostingController.removeFromParent()
                }
            let newHostingController = UIHostingController(rootView: swiftUIView)
                addChild(newHostingController)
                cell.contentView.addSubview(newHostingController.view)
                newHostingController.view.translatesAutoresizingMaskIntoConstraints = false
                
            newHostingController.view.clipsToBounds = true
            newHostingController.view.layer.cornerRadius = 20
            
                NSLayoutConstraint.activate([
                    newHostingController.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 72),
                    newHostingController.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                    newHostingController.view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
                    newHostingController.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20)
                ])

                newHostingController.didMove(toParent: self)
                hostingController = newHostingController
            
            return cell
        }
    }
}

extension AnalyticsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 700
        default:
            return 600
        }
    }
}

// MARK: - 改回來
//extension AnalyticsVC: AICellDelegate {
//    func aiButtonTapped(cell: AICell) {
//        guard !DiaryManager.shared.diaries.isEmpty else {
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 8
//            paragraphStyle.alignment = .center
//            let attributes = NSAttributedString(string: "歡迎來到AI諮商室，先到新增頁面填寫情緒日記再回來吧!",
//                                                attributes: [NSAttributedString.Key.paragraphStyle:
//                                                                paragraphStyle])
//            AlertView.instance.showAlert(
//                image: "exclamation-mark",
//                title: "哎呀!找不到日記",
//                message: attributes,
//                alertType: .empty)
//                return
//             }
//        
//        if !isLoading {
//            isLoading = true
//            cell.callAIBtn.isEnabled = false
//            showLoadingAnimation()
//            analyzeEntry {
//                cell.callAIBtn.isEnabled = true
//            }
//        }
//    }
//    
//    func analyzeEntry(completion: @escaping () -> Void)  {
//        let combinedText = latestDiaries.map { entry -> String in
//            let content = entry.content
//            let category = entry.category
//            let emotion = entry.emotion
//            
//            return "Category: \(category), Emotion: \(emotion), Diary: \(content) "
//        }.joined(separator: " ")
//        // To-DO 改回來
//        analyzeDiaryEntries(combinedText, completion: completion)
//    }
//    
//    func analyzeDiaryEntries(_ content: String, completion: @escaping () -> Void) {
//        OpenAIManager.shared.analyzeDiaryEntry(prompt: content) { [weak self] result in
//            //            guard let self = self else { return }
//            
//            DispatchQueue.main.async {
//                self?.hideLoadingAnimation()
//                
//                switch result {
//                case .success(let analyzedText):
//                    self?.AIResponse = analyzedText
//                    self?.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
//                case .failure(let error):
//                    print("Error analyzing diary entries: \(error.localizedDescription)")
//                }
//                completion()
//            }
//        }
//    }
//    
//    // Configure animation
//    private func showLoadingAnimation() {
//        loadingAnimationView = .init(name: "openAI")
//        loadingAnimationView?.frame = view.bounds
//        loadingAnimationView?.center.y -= 10
//        loadingAnimationView?.center.x -= 10
//        loadingAnimationView?.contentMode = .scaleAspectFit
//        loadingAnimationView?.loopMode = .loop
//        loadingAnimationView?.animationSpeed = 0.5
//        
//        view.addSubview(loadingAnimationView!)
//        loadingAnimationView?.play()
//    }
//    
//    private func hideLoadingAnimation() {
//        loadingAnimationView?.stop()
//        loadingAnimationView?.removeFromSuperview()
//    }
//}

// MARK: - for demo
extension AnalyticsVC: AICellDelegate {
    func aiButtonTapped(cell: AICell) {
//        guard !DiaryManager.shared.diaries.isEmpty else {
//            showAlertForNoDiary()
//            return
//        }
        
        if !isLoading {
            isLoading = true
            cell.callAIBtn.isEnabled = false
            showLoadingAnimation {
                self.analyzeEntry {
                    cell.callAIBtn.isEnabled = true
                }
            }
        }
    }
    
    func analyzeEntry(completion: @escaping () -> Void) {
        self.AIResponse = "從您的情緒日記來看，您在工作和日常生活中遇到了一些壓力和挑戰。面對工作中連續出現的bug，感到厭煩是很正常的。建議您嘗試將問題分解成小部分，逐一解決，並適時與同事溝通協助，以減輕壓力。在生活中，您似乎喜歡透過喝紅酒來放鬆，但建議不要過度依賴，可以嘗試其他健康的紓壓方式，如運動或與朋友聊天。對於您在app展示中獲得的成就感，這是非常積極的體驗，應該為自己感到自豪。整體而言，建議您保持正面思維，適當調整休息和工作的平衡。"
        self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
    
    
    private func showLoadingAnimation(completion: @escaping () -> Void) {
        loadingAnimationView = .init(name: "openAI")
        loadingAnimationView?.frame = view.bounds
        loadingAnimationView?.contentMode = .scaleAspectFit
        loadingAnimationView?.loopMode = .playOnce
        loadingAnimationView?.animationSpeed = 0.7
        
        view.addSubview(loadingAnimationView!)
        loadingAnimationView?.play { finished in
            if finished {
                self.hideLoadingAnimation()
                completion()
            }
        }
    }
    
    private func hideLoadingAnimation() {
        loadingAnimationView?.stop()
        loadingAnimationView?.removeFromSuperview()
    }
    
}



