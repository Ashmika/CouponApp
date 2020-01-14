//
//  HomeTblCell.swift
//  CouponApp
//
//  Created by Ashmika Gujarathi on 09/12/19.
//  Copyright © 2019 Ashmika. All rights reserved.
//

import UIKit

class HomeTblCell: UITableViewCell {

    @IBOutlet weak var descriptionTxt: UILabel!
    
    @IBOutlet weak var couponCode: UILabel!
    
    @IBOutlet weak var expireDatelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
