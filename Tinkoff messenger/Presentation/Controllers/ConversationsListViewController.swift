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
    
    let firebaseWorker: WorkerProtocol = FirebaseWorker()
    
    var channels: [ChannelSimple] = []
    
    let storageManager = StorageManager()
    
    var selectedChannel: ChannelSimple?
    
    var onlineConversations: [ChannelSimple] {
        get {
            return channels.filter({$0.isActive()}).sorted(by: {$0.lastActivity! > $1.lastActivity!})
        }
    }
    
    var offlineConversations: [ChannelSimple] {
        get {
            return channels.filter({!$0.isActive()}).sorted { (c1, c2) -> Bool in
                guard let a1 = c1.lastActivity else { return false }
                guard let a2 = c2.lastActivity else { return true }
                return a1 > a2
            }
        }
    }
    
    @IBAction func addChannel() {
        let alert = UIAlertController(title: "Новый Канал", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Название канала"
        }
        
        let addAction = UIAlertAction(title: "Создать", style: .default) { (myAlert) in
            guard let name = (alert.textFields![0] as UITextField).text else { return }
            self.firebaseWorker.addChannel(name: name)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
        
        storageManager.loadChannels { (channels) in
            self.channels = channels
            self.tableView.reloadData()
        }
    }
    
    func loadData() {
        firebaseWorker.getChannels { (channels) in
            self.channels = channels
            self.tableView.reloadData()
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
            selectedChannel = onlineConversations[indexPath.row]
        } else {
            selectedChannel = offlineConversations[indexPath.row]
        }
        performSegue(withIdentifier: "conversation", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var selectedChannel: ChannelSimple?
            if indexPath.section == 0 {
                selectedChannel = onlineConversations[indexPath.row]
            } else {
                selectedChannel = offlineConversations[indexPath.row]
            }
            guard let id = selectedChannel?.id else { return }
            self.channels.removeAll(where: {$0.id == id})
            self.firebaseWorker.removeChannel(id: id)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.loadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let conversationVC = segue.destination as? ConversationsViewController else { return }
        conversationVC.selectedChannel = selectedChannel
    }
    
    
}
