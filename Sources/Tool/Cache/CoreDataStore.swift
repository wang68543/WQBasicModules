//
//  CoreDataStore.swift
//  WQBasicModules
//
//  Created by iMacHuaSheng on 2021/2/22.
//

import UIKit
import CoreData

open class CoreDataStore {
    let manager: CoreDataManager
    init(_ manager: CoreDataManager) {
        self.manager = manager
    }
    
    public func numberOfItems<T>(object type: T, predicate: NSPredicate? = nil) -> Int where T: NSManagedObject {
        let request = NSFetchRequest<T>()
        request.predicate = predicate
        let moc = self.manager.mainManageContext
        request.entity = NSEntityDescription.entity(forEntityName: "SKFile", in: moc)
        request.includesSubentities = false
        do {
            let count = try moc.count(for: request)
            return count
        } catch {
            return .zero
        }
    }
 
     
    /// Inside `CoreDataBasedContentStore`
    private func load<T>(
      by predicate: NSPredicate? = nil,
      limit: Int? = nil,
        descriptors: [NSSortDescriptor]? = nil) -> [T] where T: NSManagedObject {
        let context = self.manager.mainManageContext
      /// Can not use `T.fetchRequest()` here.
      /// Either convert the `NSFetchRequest<NSFetchRequestResult>`
      /// to `NSFetchRequest<T>` explicitly or use the following `init`:
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
      do {
        fetchRequest.predicate = predicate

        if let limit = limit {
          fetchRequest.fetchLimit = limit
        }

        fetchRequest.sortDescriptors = descriptors

        return try context.fetch(fetchRequest)
      }
      catch {
        return []
      }
    }
    
    public func fetchObjects<T: NSManagedObject>(_ request: NSFetchRequest<T>, context: NSManagedObjectContext? = nil) -> [T] {
        let moc = context ?? self.manager.mainManageContext
        do {
            return try moc.fetch(request)
        } catch let error {
            debugPrint(error)
            return []
        }
    }
    public func has<T>(of type: T) -> Bool where T: NSManagedObject {
        let name = String(describing: T.self)
        let context = self.manager.mainManageContext
        self.numberOfItems(object: T) 
    }
    public func entityName<T: NSManagedObject>(for type: T) -> String  {
        return String(describing: T.self)
    }
}
