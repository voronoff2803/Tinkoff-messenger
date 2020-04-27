//
//  Channel+CoreDataClass.swift
//  
//
//  Created by Alexey on 12.04.2020.
//
//

import Foundation
import CoreData

@objc(Channel)
public class Channel: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Channel> {
        return NSFetchRequest<Channel>(entityName: "Channel")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var identifier: String?
    @NSManaged public var lastMessage: String?
    @NSManaged public var lastActivity: Date?
    @NSManaged public var messages: NSSet?
    
    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)
}
