//
//  PhotoCollageServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import RxSwift
import CoreData

protocol PhotoCollageServiceProvider: AnyObject {
    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]>
    var rx_savedImage: Observable<Void> { get }
}

final class PhotoCollageServiceProviderImpl {
    private let storageService: StorageService

    private let photoService: AddPhotoServiceProvider

    init(storageService: StorageService,
         photoService: AddPhotoServiceProvider) {
        self.storageService = storageService
        self.photoService = photoService
    }
}

extension PhotoCollageServiceProviderImpl: PhotoCollageServiceProvider {
    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]> {
        storageService.fetch(entity).asObservable()
    }

    var rx_savedImage: Observable<Void> {
        photoService.rx_savedImage.asObservable()
    }
}
