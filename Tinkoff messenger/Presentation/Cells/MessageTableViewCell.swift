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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(with model: Message) {
        messageTextLabel.text = model.content
        nameLabel.text = model.senderName
        
        let date = model.created
        if isTodayDate(date: date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            dateLabel.text = formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM"
            dateLabel.text = formatter.string(from: date)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func isTodayDate(date: Date) -> Bool {
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        let new = Calendar.current.dateComponents(in: .current, from: date)
        if now.year == new.year, now.month == new.month, now.day == new.day {
            return true
        } else {
            return false
        }
    }

    

}
