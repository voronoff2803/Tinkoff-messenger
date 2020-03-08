//
//  ConversationsViewController.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 01.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

final class ConversationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let messages = ["Хахахахаха как дела ля ля ля ля", "If you need this in the universal time (UTC, GMT, Z… whatever name you give universal time), then use the following.", "This can be done very simply using the following code. No need for date components or other complications.", "Also try adding following code in date extension"]
    
    var testData: [MessageCellModel] = []
    
    var model: ConversationCellModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = model?.name
        
        tableView.delegate = self
        tableView.dataSource = self
        
        upsidownTableView()
        
        for _ in 0...30 {
            testData.append(MessageCellModel(text: messages.randomElement()!, isIncoming: Bool.random()))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MessageTableViewCell?
        let model = testData[indexPath.row]
        if model.isIncoming {
            cell = tableView.dequeueReusableCell(withIdentifier: "incoming") as? MessageTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "outgoing") as? MessageTableViewCell
        }
        cell?.configure(with: model)
        cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell!
    }
    
    func upsidownTableView() {
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
}
