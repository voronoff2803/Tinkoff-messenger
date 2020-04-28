//
//  ConversationViewCellTableViewCell.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 01.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

final class ConversationViewCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with model: ChannelSimple) {
        nameLabel.text = model.name
        
        if let messageText = model.lastMessage {
            messageLabel.text = messageText
            messageLabel.font = UIFont.systemFont(ofSize: messageLabel.font.pointSize)
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont.italicSystemFont(ofSize: messageLabel.font.pointSize)
            dateLabel.text = ""
        }
        
        if let date = model.lastActivity {
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
//        if #available(iOS 13.0, *) {
//            if model.isOnline {
//                backgroundColor = UIColor.blend(color1: .systemBackground, intensity1: 0.8, color2: .yellow, intensity2: 0.2)
//            } else {
//                backgroundColor = .systemBackground
//            }
//        } else {
//            if model.isOnline {
//                backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
//            } else {
//                backgroundColor = .white
//            }
//        }
        
//        if model.hasUnreadMessages {
//            messageLabel.font = UIFont.systemFont(ofSize: messageLabel.font.pointSize, weight: .semibold)
//        } else {
//            messageLabel.font = UIFont.systemFont(ofSize: messageLabel.font.pointSize, weight: .regular)
//        }
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
