//
//  MessageTableViewCell.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 01.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

final class MessageTableViewCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var messageTextLabel: UILabel!
    
    func configure(with model: MessageCellModel) {
        messageTextLabel.text = model.text
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
