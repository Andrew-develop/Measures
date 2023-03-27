//
//  MeasurementServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import RxSwift

protocol MeasurementServiceProvider: AnyObject {
    var rx_getParameters: Observable<[Parameter]?> { get }
    func rx_getNotes(predicate: NSPredicate?) -> Observable<[Note]?>

    func addNote(_ body: @escaping (inout Note) -> Void) -> Observable<Note>
    func addMeasurement(_ body: @escaping (inout Measurement) -> Void) -> Observable<Measurement>
    func updateNote() -> Observable<Void>
}

final class MeasurementServiceProviderImpl {
    private let notesStorage: StorageService<Note>
    private let parametersStorage: StorageService<Parameter>
    private let measurementsStorage: StorageService<Measurement>

    init(notesStorage: StorageService<Note>,
         parametersStorage: StorageService<Parameter>,
         measurementsStorage: StorageService<Measurement>) {
        self.notesStorage = notesStorage
        self.parametersStorage = parametersStorage
        self.measurementsStorage = measurementsStorage
    }
}

extension MeasurementServiceProviderImpl: MeasurementServiceProvider {
    var rx_getParameters: Observable<[Parameter]?> {
        parametersStorage.fetch().asObservable()
    }

    func rx_getNotes(predicate: NSPredicate?) -> Observable<[Note]?> {
        notesStorage.fetch(predicate: predicate).asObservable()
    }

    func addNote(_ body: @escaping (inout Note) -> Void) -> Observable<Note> {
        notesStorage.add(body).asObservable()
    }

    func addMeasurement(_ body: @escaping (inout Measurement) -> Void) -> Observable<Measurement> {
        measurementsStorage.add(body).asObservable()
    }

    func updateNote() -> Observable<Void> {
        notesStorage.update().asObservable()
    }
}
