//
//  HomeServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import RxSwift
import CoreData

protocol HomeServiceProvider: AnyObject {
    func create<T: NSManagedObject>(_ entity: T.Type,
                                    _ body: @escaping (inout T) -> Void) -> Observable<T>

    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]>
    var rx_savedImage: Observable<Void> { get }
    func playHaptic(intensity: Float, sharpness: Float)
}

final class HomeServiceProviderImpl {
    private let storageService: StorageService
    private let photoService: AddPhotoServiceProvider
    private let hapticService: HapticService

    init(storageService: StorageService,
         photoService: AddPhotoServiceProvider,
         hapticService: HapticService) {
        self.storageService = storageService
        self.photoService = photoService
        self.hapticService = hapticService
    }
}

extension HomeServiceProviderImpl: HomeServiceProvider {
    func create<T: NSManagedObject>(_ entity: T.Type,
                                    _ body: @escaping (inout T) -> Void) -> Observable<T> {
        storageService.create(entity, body).asObservable()
    }

    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]> {
        storageService.fetch(entity).asObservable()
    }

    func playHaptic(intensity: Float, sharpness: Float) {
        hapticService.playHaptic(intensity: intensity, sharpness: sharpness)
    }

    var rx_savedImage: Observable<Void> {
        photoService.rx_savedImage.asObservable()
    }
}
