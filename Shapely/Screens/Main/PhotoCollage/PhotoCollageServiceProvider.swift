//
//  PhotoCollageServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import RxSwift

protocol PhotoCollageServiceProvider: AnyObject {
    var rx_getNotes: Observable<[Note]?> { get }
    var rx_getPhotos: Observable<[Photo]?> { get }
    var rx_savedImage: Observable<Void> { get }
}

final class PhotoCollageServiceProviderImpl {
    private let notesStorage: StorageService<Note>
    private let photosStorage: StorageService<Photo>

    private let photoService: AddPhotoServiceProvider

    init(notesStorage: StorageService<Note>,
         photosStorage: StorageService<Photo>,
         photoService: AddPhotoServiceProvider) {
        self.notesStorage = notesStorage
        self.photosStorage = photosStorage
        self.photoService = photoService
    }
}

extension PhotoCollageServiceProviderImpl: PhotoCollageServiceProvider {
    var rx_getNotes: Observable<[Note]?> {
        notesStorage.fetch().asObservable()
    }

    var rx_getPhotos: Observable<[Photo]?> {
        photosStorage.fetch().asObservable()
    }

    var rx_savedImage: Observable<Void> {
        photoService.rx_savedImage.asObservable()
    }
}
