//
//  PostDetailVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import UIKit

// Define cells


class PostDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var emotion: String? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    // MARK: - Cell Arrangement
  


}

extension PostDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath) as! DateCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "emotion", for: indexPath) as! EmotionCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! CategoryCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textfield", for: indexPath) as! TextFieldCell
            return cell
        }
    }
}

extension PostDetailVC: UITableViewDelegate {
    
}



