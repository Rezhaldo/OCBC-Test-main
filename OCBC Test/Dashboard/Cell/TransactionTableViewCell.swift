//
//  TransactionTableViewCell.swift
//  OCBC Test
//
//  Created by Kevin Chilmi Rezhaldo on 21/05/22.
//

import UIKit
import Alamofire


class TransactionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelReceipientName: UILabel!
    @IBOutlet weak var labelAccountNoReceipient: UILabel!
    @IBOutlet weak var labelAmountTransfer: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
    }
    
    func setData(data: TransactionData) {
        labelReceipientName.text = data.receipient?.accountHolder
        labelAmountTransfer.text = "\(data.amount ?? 0)"
        labelAccountNoReceipient.text = data.receipient?.accountNo
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
