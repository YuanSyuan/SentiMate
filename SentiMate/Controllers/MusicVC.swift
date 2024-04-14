//
//  MusicVC.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/10.
//

import UIKit

class MusicVC: UIViewController {

    let musicManager = MusicManager()
    var songs: [StoreItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("========== Songs passed to MusicVC: \(songs)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }


}

