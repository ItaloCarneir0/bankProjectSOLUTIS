//
//  customCell.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 18/10/21.
//

import UIKit

class extratoCustomCell: UITableViewCell {

    @IBOutlet weak var lbExtratoValor: UILabel!
    
    @IBOutlet weak var lbExtratoDesc: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
