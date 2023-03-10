//
//  StorageService.swift
//  Shapely
//
//  Created by Andrew on 10.03.2023.
//

import CoreData
import RxSwift

final class StorageService<Entity: NSManagedObject> {
    private let persistentContainer = NSPersistentContainer(name: "Shapely")
    private let context: NSManagedObjectContext

    init() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        context = persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }

    func fetch(sortDescriptors: [NSSortDescriptor] = [],
               predicate: NSPredicate? = nil) -> Observable<[Entity]?> {
        return Observable<[Entity]?>.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }
            let request = Entity.fetchRequest()
            request.sortDescriptors = sortDescriptors
            request.predicate = predicate
            do {
                let results = try self.context.fetch(request) as? [Entity]
                observer.onNext(results)
                observer.onCompleted()
                return Disposables.create()
            } catch {
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }

    func add(_ body: @escaping (inout Entity) -> Void) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }
            var entity = Entity(context: self.context)
            body(&entity)
            do {
                try self.context.save()
                observer.onNext(Void())
                observer.onCompleted()
                return Disposables.create()
            } catch {
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }
}
