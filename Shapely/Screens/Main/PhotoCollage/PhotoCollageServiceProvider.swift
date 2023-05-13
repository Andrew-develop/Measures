//
//  PhotoCollageServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import RxSwift
import CoreData
import PDFKit

protocol PhotoCollageServiceProvider: AnyObject {
    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]>
    var rx_savedImage: Observable<Void> { get }
    func getPDF() -> PDFDocument
}

final class PhotoCollageServiceProviderImpl {
    private let storageService: StorageService
    private let photoService: AddPhotoServiceProvider
    private let pdfService: PDFService

    init(storageService: StorageService,
         photoService: AddPhotoServiceProvider,
         pdfService: PDFService) {
        self.storageService = storageService
        self.photoService = photoService
        self.pdfService = pdfService
    }
}

extension PhotoCollageServiceProviderImpl: PhotoCollageServiceProvider {
    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]> {
        storageService.fetch(entity).asObservable()
    }

    var rx_savedImage: Observable<Void> {
        photoService.rx_savedImage.asObservable()
    }

    func getPDF() -> PDFDocument {
        pdfService.createFlyer()
    }
}
