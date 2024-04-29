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
    private var latestDiaries: [Diary] {
        Array(DiaryManager.shared.diaries.prefix(7))
    }
    var AIResponse: String?
    private var loadingAnimationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(diariesDidUpdate), name: NSNotification.Name("DiariesUpdated"), object: nil)
        
        firebaseManager.onNewData = { newDiaries in
            DiaryManager.shared.updateDiaries(newDiaries: newDiaries)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
                cell.AIResponseLbl.textAlignment = .left
                cell.AIResponseLbl.text = AIResponse
            } else {
                cell.AIResponseLbl.textAlignment = .center
                cell.AIResponseLbl.text = "最近七筆日記裡面，情緒有些變動呢\n點擊下方按鈕查看AI分析吧！"
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as? ChartCell else {
                fatalError("Could not dequeue ChartCell") }
            
            let emotionTypes = DiaryManager.shared.getEmotionTypes(forPeriod: .allTime)
            let swiftUIView = DonutChartView(emotionTypes: emotionTypes)
            // If we already have a hosting controller, just update the SwiftUI view
            if let hostingController = hostingController {
                hostingController.rootView = swiftUIView
            } else {
                // Create the hosting controller with the SwiftUI view
                let newHostingController = UIHostingController(rootView: swiftUIView)
                cell.contentView.addSubview(newHostingController.view)
                newHostingController.view.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    newHostingController.view.topAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.topAnchor),
                    newHostingController.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                    newHostingController.view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                    newHostingController.view.bottomAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.bottomAnchor)
                ])
                
                newHostingController.didMove(toParent: self)
                hostingController = newHostingController
            }
            return cell
        }
    }
}

extension AnalyticsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return view.bounds.height
        default:
            return 560
        }
    }
}

extension AnalyticsVC: AICellDelegate {
    
    
    func aiButtonTapped() {
        showLoadingAnimation()
        analyzeEntry()
    }
    
    func analyzeEntry() {
        let combinedText = latestDiaries.map { entry -> String in
            let content = entry.content
            let category = entry.category
            let emotion = entry.emotion
            
            return "Category: \(category), Emotion: \(emotion), Diary: \(content) "
        }.joined(separator: " ")
        
        analyzeDiaryEntries(combinedText)
    }
    
    func analyzeDiaryEntries(_ content: String) {
        OpenAIManager.shared.analyzeDiaryEntry(prompt: content) { [weak self] result in
            //            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self?.hideLoadingAnimation()
                
                switch result {
                case .success(let analyzedText):
                    self?.AIResponse = analyzedText
                    self?.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
                case .failure(let error):
                    print("Error analyzing diary entries: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showLoadingAnimation() {
        loadingAnimationView = .init(name: "openAI")
        loadingAnimationView?.frame = view.bounds
        loadingAnimationView?.center.y += 15
        loadingAnimationView?.center.x -= 10
        loadingAnimationView?.contentMode = .scaleAspectFit
        loadingAnimationView?.loopMode = .loop
        loadingAnimationView?.animationSpeed = 0.5
        
        view.addSubview(loadingAnimationView!)
        loadingAnimationView?.play()
    }
    
    private func hideLoadingAnimation() {
        loadingAnimationView?.stop()
        loadingAnimationView?.removeFromSuperview()
    }
}




