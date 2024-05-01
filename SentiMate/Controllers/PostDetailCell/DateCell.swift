//
//  DateCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import UIKit

class DateCell: UITableViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var onDateChanged: ((Date) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        onDateChanged?(sender.date)
    }
    
    func setDate(_ date: Date) {
        self.datePicker.date = date
    }
    
}

