//
//  StorageService.swift
//  Shapely
//
//  Created by Andrew on 10.03.2023.
//

import CoreData
import RxSwift

final class StorageService<Entity: NSManagedObject> {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
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

    func add(_ body: @escaping (inout Entity) -> Void) -> Observable<Entity> {
        return Observable<Entity>.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }
            var entity = Entity(context: self.context)
            body(&entity)
            do {
                try self.context.save()
                observer.onNext(entity)
                observer.onCompleted()
                return Disposables.create()
            } catch {
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }

    func update() -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }
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

    func delete(_ entity: Entity) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }
            do {
                self.context.delete(entity)
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
