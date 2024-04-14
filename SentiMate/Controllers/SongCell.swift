//
//  SongCell.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/14.
//

import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var songImg: UIImageView!
    @IBOutlet weak var songLbl: UILabel!
    @IBOutlet weak var singerLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
