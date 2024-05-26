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
import Combine

class AnalyticsVC: UIViewController {
    @ObservedObject private var viewModel = AnalyticsViewModel()
    private var tableView: UITableView!
    private var hostingController: UIHostingController<DonutChartView>?
    var isLoading = false
    private var loadingAnimationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.$diaries
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$AIResponse
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if let cell = self?.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? AICell {
                    cell.updateAIResponse(with: self?.viewModel.AIResponse)
                }
            }
            .store(in: &viewModel.cancellables)
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

// MARK: - AnalyticsVC - UITableViewDataSource, UITableViewDelegate
extension AnalyticsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AICell", for: indexPath) as? AICell else {
                fatalError("Could not dequeue AICell") }
            
            cell.delegate = self
            cell.configureEmojis(with: viewModel.latestDiaries.reversed().map { $0.emotion })
            cell.updateAIResponse(with: viewModel.AIResponse)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as? ChartCell else {
                fatalError("Could not dequeue ChartCell") }
            
            let emotionTypes = DiaryManager.shared.getEmotionTypes(forPeriod: .allTime)
            let swiftUIView = DonutChartView(emotionTypes: emotionTypes)
            
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

extension AnalyticsVC: AICellDelegate {
    func aiButtonTapped(cell: AICell) {
        guard !viewModel.diaries.isEmpty else {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8
            paragraphStyle.alignment = .center
            let attributes = NSAttributedString(string: "歡迎來到AI諮商室，先到新增頁面填寫情緒日記再回來吧!",
                                                attributes: [NSAttributedString.Key.paragraphStyle:
                                                                paragraphStyle])
            AlertView.instance.showAlert(
                image: "exclamation-mark",
                title: "哎呀!找不到日記",
                message: attributes,
                alertType: .empty)
            return
        }
        
        if !isLoading {
            isLoading = true
            cell.callAIBtn.isEnabled = false
            showLoadingAnimation()
            viewModel.analyzeEntry {
                cell.callAIBtn.isEnabled = true
                self.hideLoadingAnimation()
                // 未來可增加 alert 提醒今日已經玩過了，避免重複點按
            }
        }
    }
    
    private func showLoadingAnimation() {
        loadingAnimationView = .init(name: "openAI")
        loadingAnimationView?.frame = view.bounds
        loadingAnimationView?.center.y -= 10
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





