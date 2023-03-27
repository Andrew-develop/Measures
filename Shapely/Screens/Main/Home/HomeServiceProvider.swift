//
//  HomeServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import RxSwift

protocol HomeServiceProvider: AnyObject {
    var rx_getUserData: Observable<[User]?> { get }
    var rx_getPhotos: Observable<[Photo]?> { get }
    var rx_getMeasurements: Observable<[Measurement]?> { get }
    var rx_getParameters: Observable<[Parameter]?> { get }
    var rx_savedImage: Observable<Void> { get }
    func rx_getNotes(predicate: NSPredicate?) -> Observable<[Note]?>
    func addUser(_ body: @escaping (inout User) -> Void) -> Observable<User>
}

final class HomeServiceProviderImpl {
    private let userStorage: StorageService<User>
    private let notesStorage: StorageService<Note>
    private let photosStorage: StorageService<Photo>
    private let measurementsStorage: StorageService<Measurement>
    private let parametersStorage: StorageService<Parameter>

    private let photoService: AddPhotoServiceProvider

    init(userStorage: StorageService<User>,
         notesStorage: StorageService<Note>,
         photosStorage: StorageService<Photo>,
         measurementsStorage: StorageService<Measurement>,
         parametersStorage: StorageService<Parameter>,
         photoService: AddPhotoServiceProvider) {
        self.userStorage = userStorage
        self.notesStorage = notesStorage
        self.photosStorage = photosStorage
        self.measurementsStorage = measurementsStorage
        self.parametersStorage = parametersStorage
        self.photoService = photoService
    }
}

extension HomeServiceProviderImpl: HomeServiceProvider {
    var rx_getUserData: Observable<[User]?> {
        userStorage.fetch().asObservable()
    }

    var rx_getPhotos: Observable<[Photo]?> {
        photosStorage.fetch().asObservable()
    }

    var rx_getMeasurements: Observable<[Measurement]?> {
        measurementsStorage.fetch().asObservable()
    }

    var rx_getParameters: Observable<[Parameter]?> {
        parametersStorage.fetch().asObservable()
    }

    func rx_getNotes(predicate: NSPredicate?) -> Observable<[Note]?> {
        notesStorage.fetch(predicate: predicate).asObservable()
    }

    func addUser(_ body: @escaping (inout User) -> Void) -> Observable<User> {
        userStorage.add(body).asObservable()
    }

    var rx_savedImage: Observable<Void> {
        photoService.rx_savedImage.asObservable()
    }
}
