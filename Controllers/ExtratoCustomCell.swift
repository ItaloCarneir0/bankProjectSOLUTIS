//
//  customCell.swift
//  SolutisLogin
//
//  Created by Virtual Machine on 18/10/21.
//

import UIKit

class ExtratoCustomCell: UITableViewCell {
    
    @IBOutlet weak var lbExtratoValor: UILabel!
    
    @IBOutlet weak var lbExtratoDesc: UILabel!

    @IBOutlet weak var lbExtratoStatus: UILabel!
    
    @IBOutlet weak var lbExtratoData: UILabel!
    
//    var extrato: StatementResponse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

