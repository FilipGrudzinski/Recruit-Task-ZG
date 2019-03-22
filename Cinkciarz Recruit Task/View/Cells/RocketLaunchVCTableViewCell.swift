//
//  RocketLaunchVCTableViewCell.swift
//  Cinkciarz Recruit Task
//
//  Created by Filip on 21/03/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit

class RocketLaunchVCTableViewCell: UITableViewCell {

    @IBOutlet weak var rocketNameLabel: UILabel!
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var rocketLaunchDate: UILabel!
    @IBOutlet weak var rocketStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        rocketNameLabel.adjustsFontSizeToFitWidth = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func prepareForReuse() {
        rocketNameLabel.text = ""
        shortNameLabel.text = ""
        rocketLaunchDate.text = ""
        rocketStatusLabel.text = ""

    }
    
}
