//
//  MyTestCell.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/12/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class MyTestCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
