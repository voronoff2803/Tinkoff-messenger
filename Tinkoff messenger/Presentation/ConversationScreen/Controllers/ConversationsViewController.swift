//
//  ConversationsViewController.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 01.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

final class ConversationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    
    let firebaseWorker: WorkerProtocol = FirebaseWorker()
    let storageManager = StorageManager()
    var messages: [MessageSimple] = []
    var selectedChannel: ChannelSimple?
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        if updatedString == "" {
            setSendButton(active: false)
        } else {
            setSendButton(active: true)
        }
        return true
    }
    
    var isSendButtonActive = false
    
    func setSendButton(active: Bool) {
        if active && !isSendButtonActive {
            self.sendButton.isUserInteractionEnabled = true
            isSendButtonActive = true
            UIView.animate(withDuration: 0.2, animations: {
                self.sendButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.sendButton.setTitleColor(.systemBlue, for: .normal)
            }) { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.sendButton.transform = .identity
                })
            }
        } else if !active && isSendButtonActive {
            self.sendButton.isUserInteractionEnabled = false
            isSendButtonActive = false
            UIView.animate(withDuration: 0.2, animations: {
                self.sendButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.sendButton.setTitleColor(.gray, for: .normal)
            }) { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.sendButton.transform = .identity
                })
            }
        }
    }
    
    @IBAction func sendMessageAction() {
        if let identifier = selectedChannel?.id {
            if let message = textField.text {
                firebaseWorker.addMessage(channelIdentifier: identifier, content: message)
                textField.text = ""
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sendButton.setTitleColor(.gray, for: .normal)
        self.sendButton.isUserInteractionEnabled = false
        
        hideKeyboardWhenTappedAround()
        title = selectedChannel?.name
        
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        
        upsidownTableView()
        
        if let identifier = selectedChannel?.id {
            firebaseWorker.getMessages(channelIdentifier: identifier) { (messages) in
                self.messages = messages.sorted(by: { $0.created > $1.created })
                self.tableView.reloadData()
                if let channelId = self.selectedChannel?.id {
                    self.storageManager.saveMessages(simpleMessages: messages, channelId: channelId)
                }
            }
            
            storageManager.loadMessages(channelId: identifier) { (messages) in
                self.messages = messages.sorted(by: { $0.created > $1.created })
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MessageTableViewCell?
        let model = messages[indexPath.row]
        if model.isIncoming() {
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
           keyboardConstraint.constant = 0 + keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
       keyboardConstraint.constant = 0
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
