//
//  ResultCell.swift
//  yelp
//
//  Created by CHRISTOPHER HINRICHS on 9/20/14.
//  Copyright (c) 2014 CHRISTOPHER HINRICHS. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var resultDescription: UILabel!
    @IBOutlet weak var resultAddress: UILabel!
    @IBOutlet weak var resultCost: UILabel!
    @IBOutlet weak var resultNumReviews: UILabel!
    @IBOutlet weak var resultName: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultRatingImg: UIImageView!
    @IBOutlet weak var resultDistance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
