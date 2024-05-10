//
//  DateCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/11.
//

import UIKit

class DateCell: UITableViewCell {
    
    @IBOutlet weak var todayLbl: UILabel!
    
    let datePicker = UIDatePicker()
    var onDateChanged: ((Date) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        datePicker.tintColor = defaultBackgroundColor
        datePicker.datePickerMode = .date
        datePicker.layer.backgroundColor = defaultTextColor.cgColor
        datePicker.layer.cornerRadius = 8
        datePicker.sizeToFit()
        datePicker.frame = .init(x: 0, y: 0, 
                                 width: datePicker.bounds.size.width,
                                 height: datePicker.bounds.size.height)
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        contentView.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
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

