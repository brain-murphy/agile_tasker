//
//  TaskTableViewCell.swift
//  agile-tasker
//
//  Created by Abhishek Sen on 9/24/16.
//  Copyright © 2016 Brian Murphy. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var workLeftLabel: UILabel!
    @IBOutlet weak var workRemainingLabel: UILabel!
    @IBOutlet weak var urgencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        showsReorderControl = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
