//
//  AnswerQuestionCell.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/8/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class AnswerQuestionCell: UITableViewCell {

    var question: QuestionObject?
    
    @IBOutlet weak var imgRecord: UIImageView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgPush: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
