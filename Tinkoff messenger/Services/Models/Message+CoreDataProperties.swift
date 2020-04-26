//
//  Message+CoreDataProperties.swift
//  
//
//  Created by Alexey on 12.04.2020.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var content: String?
    @NSManaged public var created: Date?
    @NSManaged public var senderID: String?
    @NSManaged public var senderName: String?
    @NSManaged public var id: NSObject?

}
