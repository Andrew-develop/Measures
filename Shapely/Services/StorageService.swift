//
//  CoreDataService.swift
//  Shapely
//
//  Created by Andrew on 28.03.2023.
//

import CoreData
import RxSwift

final class StorageService: NSObject {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func create<T: NSManagedObject>(_ entity: T.Type, _ body: @escaping (inout T) -> Void) -> Observable<T> {
        return Observable<T>.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }
            var entity = T(context: self.context)
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

    func fetch<T: NSManagedObject>(_ entity: T.Type,
                                      sortDescriptors: [NSSortDescriptor] = [],
                                      predicate: NSPredicate? = nil) -> Observable<[T]> {
        return Observable<[T]>.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }

            let request = NSFetchRequest<T>(entityName: String(describing: entity))
            request.sortDescriptors = sortDescriptors
            request.predicate = predicate

            do {
                let results = try self.context.fetch(request)
                observer.onNext(results)
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

    func delete(_ object: NSManagedObject) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }
            do {
                self.context.delete(object)
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
