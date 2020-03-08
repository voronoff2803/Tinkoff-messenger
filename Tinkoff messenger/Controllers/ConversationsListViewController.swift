//
//  ConversationsListViewController.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 01.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

final class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let names = ["Антон Антонов", "Егор Летов", "Иван Овнов", "Егор Погром"]
    let messages = ["Хахахахаха как дела ля ля ля ля", "If you need this in the universal time (UTC, GMT, Z… whatever name you give universal time), then use the following.", "This can be done very simply using the following code. No need for date components or other complications.", "Also try adding following code in date extension"]
    var testData: [ConversationCellModel] = []
    
    var selectedModel: ConversationCellModel?
    
    var onlineConversations: [ConversationCellModel] {
        get {
            return testData.filter({$0.isOnline})
        }
    }
    
    var offlineConversations: [ConversationCellModel] {
        get {
            return testData.filter({!$0.isOnline})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        for _ in 0...30 {
            testData.append(ConversationCellModel(name: names.randomElement()!, message: messages.randomElement()!, date: Date().addingTimeInterval(Double.random(in: -500000...0)), isOnline: Bool.random(), hasUnreadMessages: Bool.random()))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return onlineConversations.count
        } else {
            return offlineConversations.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "online"
        } else {
            return "offline"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ConversationViewCell
        if indexPath.section == 0 {
            cell.configure(with: onlineConversations[indexPath.row])
        } else {
            cell.configure(with: offlineConversations[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        if indexPath.section == 0 {
            selectedModel = onlineConversations[indexPath.row]
        } else {
            selectedModel = offlineConversations[indexPath.row]
        }
        performSegue(withIdentifier: "conversation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let conversationVC = segue.destination as? ConversationsViewController else { return }
        conversationVC.model = selectedModel
    }
    
    
}
