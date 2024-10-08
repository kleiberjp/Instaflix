//
//  CoreDataHelpers.swift
//  Instaflix
//
//  Created by Kleiber Perez on 11/09/24.
//

import CoreData

// MARK: Entity Manager

protocol ManagedEntity: NSFetchRequestResult { }

extension ManagedEntity where Self: NSManagedObject {
    
    static var entityName: String {
        let nameMO = String(describing: Self.self)
        let suffixIndex = nameMO.index(nameMO.endIndex, offsetBy: -2)
        return String(nameMO[..<suffixIndex])
    }
    
    static func insertNew(in context: NSManagedObjectContext) -> Self? {
        return NSEntityDescription
            .insertNewObject(forEntityName: entityName, into: context) as? Self
    }
    
    static func newFetchRequest() -> NSFetchRequest<Self> {
        return .init(entityName: entityName)
    }
}

// MARK: Misc

extension NSSet {
    func toArray<T>(of type: T.Type) -> [T] {
        allObjects.compactMap { $0 as? T }
    }
}
