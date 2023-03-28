//
//  AddPhotoServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 13.03.2023.
//

import RxSwift
import CoreData

protocol AddPhotoServiceProvider: AnyObject {
    func prepareImage(_ image: UIImage)
    func notify()
    func create<T: NSManagedObject>(_ entity: T.Type,
                                    _ body: @escaping (inout T) -> Void) -> Observable<T>

    var rx_maskedImage: Observable<UIImage> { get }
    var rx_savedImage: Observable<Void> { get }
}

final class AddPhotoServiceProviderImpl {
    private let mlService: MLService
    private let storageService: StorageService

    private let savedImageSubject = PublishSubject<Void>()

    init(mlService: MLService,
         storageService: StorageService) {
        self.mlService = mlService
        self.storageService = storageService
    }
}

extension AddPhotoServiceProviderImpl: AddPhotoServiceProvider {
    func prepareImage(_ image: UIImage) {
        mlService.runVisionRequest(with: image)
    }

    func create<T: NSManagedObject>(_ entity: T.Type,
                                    _ body: @escaping (inout T) -> Void) -> Observable<T> {
        storageService.create(entity, body).asObservable()
    }

    func notify() {
        savedImageSubject.onNext(Void())
    }

    var rx_maskedImage: Observable<UIImage> {
        mlService.rx_maskedImage.asObservable()
    }

    var rx_savedImage: Observable<Void> {
        savedImageSubject.asObserver()
    }
}
