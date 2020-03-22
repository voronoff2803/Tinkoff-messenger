//
//  WorkerProtocol.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 22.03.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import Foundation

protocol WorkerProtocol {
    func getChannels(channelListener: @escaping (_ channels: [Channel])->())
    func getMessages(channelIdentifier: String, messageListener: @escaping (_ messages: [Message])->())
    func addChannel(name: String)
    func addMessage(channelIdentifier: String, content: String)
}
