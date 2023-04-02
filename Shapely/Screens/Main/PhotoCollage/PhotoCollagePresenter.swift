//
//  PhotoCollagePresenter.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import RxSwift
import RxCocoa

final class PhotoCollagePresenter: PropsProducer {
    typealias Props = PhotoCollageViewController.Props

    private let service: PhotoCollageServiceProvider
    private let router: PhotoCollageInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    private var categories: [Angel: [AnyHashable]] = [:] {
        didSet {
            propsRelay.mutate {
                $0.category = categories
            }
        }
    }

    init(service: PhotoCollageServiceProvider, router: PhotoCollageInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension PhotoCollagePresenter {
    func setup() {
        getPhotos()

        propsRelay.mutate {
            $0.title = R.string.localizable.photoCollageTitle()
        }

        service.rx_savedImage
            .bind { [weak self] in
                self?.getPhotos()
            }
            .disposed(by: disposeBag)
    }

    func getPhotos() {
        service.fetch(Photo.self)
            .bind { [weak self] photos in
                self?.mapPhotoCategories(photos.reversed())
            }
            .disposed(by: disposeBag)
    }

    func mapPhotoCategories(_ photos: [Photo]) {
        Angel.allCases.forEach { [weak self] angel in
            guard let self else { return }
            let categoryPhotos = photos.filter { $0.angel == angel.description }
            let title = InitialStartTitleCellViewModel(props: .init(title: angel.description))
            let values = PhotoTypesCellViewModel(
                props: .init(
                    id: UUID(),
                    items: self.mapPhotos(categoryPhotos)
                )
            )
            let addWidget = AddWidgetCellViewModel(
                props: .init(
                    title: R.string.localizable.photoCollageAddPhoto(),
                    onTap: Command {
                        self.router.runAddPhotoScreen()
                    }
                )
            )
            self.categories[angel] = !categoryPhotos.isEmpty ? [title, values, addWidget] : [title, addWidget]
        }
    }

    func mapPhotos(_ photos: [Photo]) -> [PhotoVariantCellViewModel] {
        photos.map { photo in
            PhotoVariantCellViewModel(
                props: .init(
                    id: UUID(),
                    image: UIImage(data: photo.value ?? Data()),
                    onTap: .empty
                )
            )
        }
    }
}
