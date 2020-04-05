//
//  Profile+CoreDataProperties.swift
//  Tinkoff messenger
//
//  Created by Алексей Воронов on 05.04.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var name: String?
    @NSManaged public var bio: String?
    @NSManaged public var image: Data?

}
