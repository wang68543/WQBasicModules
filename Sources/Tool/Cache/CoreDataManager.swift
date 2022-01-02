//
//  CoreDataManager.swift
//  WQBasicModules
//
//  Created by iMacHuaSheng on 2021/2/22.
//

import UIKit
import CoreData

open class CoreDataManager {
    private let modleName: String
    // default main
    private let bundle: Bundle?
    init(_ name: String, bundle: Bundle?) {
        self.modleName = name
        self.bundle = bundle
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextDidSaveObjects(_:)), name: .NSManagedObjectContextDidSave, object: self.privateManageContext)
        // NSManagedObjectContextObjectsDidChange
    }
//    public static let shared = CoreDataManagerX(modleName: "Model")

    @objc func managedObjectContextDidSaveObjects(_ note: Notification) {
        if let uinfo = note.userInfo,
           let objs = uinfo[NSInsertedObjectsKey] ??
            uinfo[NSDeletedObjectsKey] ??
            uinfo[NSUpdatedObjectsKey] ??
            uinfo[NSRefreshedObjectsKey] ??
            uinfo[NSInvalidatedAllObjectsKey],
        let objects = objs as? Set<NSManagedObject>,
        let obj = objects.first {
            let nameString: String = String(describing: type(of: obj))
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: CoreDataManager.didChange, object: nameString, userInfo: uinfo)
            }
        } else { //
            DispatchQueue.main.async {
                let entities = self.manageObjectModel.entities
                for entity in entities {
                    NotificationCenter.default.post(name: CoreDataManager.didChange, object: entity.managedObjectClassName!, userInfo: note.userInfo)
                }
            }
        }
    }

    private lazy var manageObjectModel: NSManagedObjectModel = {
        let dataBundle = bundle ?? .main
        guard let modelURL = dataBundle.url(forResource: self.modleName, withExtension: "momd") else {
            fatalError("can't find data file")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("can't create data modal")
        }
        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.manageObjectModel)
        let documentDirectpryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistenStoreUrl = documentDirectpryUrl.appendingPathComponent("\(self.modleName).sqlite")

        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistenStoreUrl, options: options)
        } catch {
            fatalError("cannot load perisitent store on \(persistenStoreUrl)")
        }
        return persistentStoreCoordinator
    }()

    private lazy var privateManageContext: NSManagedObjectContext = {
        let manageObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        manageObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        manageObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return manageObjectContext
    }()

    public private(set) lazy var mainManageContext: NSManagedObjectContext = {
        let manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        manageObjectContext.parent = self.privateManageContext
        manageObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        return manageObjectContext
    }()

    public func backgroundContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = self.privateManageContext
        return managedObjectContext
    }

    public func save(moc: NSManagedObjectContext) {
        // Make sure all changes are committed into its parent.
        // 这里不封装起来
      moc.performAndWait {
        do {
          if moc.hasChanges {
            try moc.save()
          }
        } catch {
          print("Cannot save changes of background managed object context.")
          print("\(error), \(error.localizedDescription)")
        }
      }
        privateManageContext.perform {
            do {
              if self.privateManageContext.hasChanges {
                try self.privateManageContext.save()
              }
            } catch {
              print("Cannot save changes of private managed object context to core data storage.")
              print("\(error), \(error.localizedDescription)")
            }
          }
    }

    public func save() {
        privateManageContext.performAndWait {
            do {
              if self.privateManageContext.hasChanges {
                try self.privateManageContext.save()
              }
            } catch {
              print("Cannot save changes of private managed object context to core data storage.")
              print("\(error), \(error.localizedDescription)")
            }
          }
    }

    public func clearStorage(entityName: String) {
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
        entityName: entityName)
      let batchDeleteRequest = NSBatchDeleteRequest(
        fetchRequest: fetchRequest)
        let moc = self.backgroundContext()
        moc.performAndWait {
            do {
              try moc.execute(batchDeleteRequest)
            } catch {
              print("Cannot delete local storage for: \(entityName).\n Reason: \(error.localizedDescription)")
            }
        }
        NotificationCenter.default.post(name: CoreDataManager.didChange, object: entityName, userInfo: nil)
    }
}
public extension CoreDataManager {
    static let didChange = NSNotification.Name(rawValue: "CoreDataManagerDidChange")
}
