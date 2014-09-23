//
//  FilterCell.swift
//  yelp
//
//  Created by CHRISTOPHER HINRICHS on 9/22/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    
    @IBOutlet weak var toggleSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
