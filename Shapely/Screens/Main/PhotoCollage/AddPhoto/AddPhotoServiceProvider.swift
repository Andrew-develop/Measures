//
//  AddPhotoServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 13.03.2023.
//

import RxSwift

protocol AddPhotoServiceProvider: AnyObject {
    func prepareImage(_ image: UIImage)
    func notify()
    func addPhoto(_ body: @escaping (inout Photo) -> Void) -> Observable<Photo>

    var rx_maskedImage: Observable<UIImage> { get }
    var rx_savedImage: Observable<Void> { get }
}

final class AddPhotoServiceProviderImpl {
    private let mlService: MLService
    private let photosStorage: StorageService<Photo>

    private let savedImageSubject = PublishSubject<Void>()

    init(mlService: MLService,
         photosStorage: StorageService<Photo>) {
        self.mlService = mlService
        self.photosStorage = photosStorage
    }
}

extension AddPhotoServiceProviderImpl: AddPhotoServiceProvider {
    func prepareImage(_ image: UIImage) {
        mlService.runVisionRequest(with: image)
    }

    func addPhoto(_ body: @escaping (inout Photo) -> Void) -> Observable<Photo> {
        photosStorage.add(body).asObservable()
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
