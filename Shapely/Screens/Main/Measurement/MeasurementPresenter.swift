//
//  MeasurementPresenter.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import RxSwift
import RxCocoa

final class MeasurementPresenter: PropsProducer {
    typealias Props = MeasurementViewController.Props

    private let service: MeasurementServiceProvider
    private let router: MeasurementInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    init(service: MeasurementServiceProvider, router: MeasurementInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension MeasurementPresenter {
    func setup() {
        let predicate = NSPredicate(format: "date >= %@", Calendar.current.startOfDay(for: Date()) as CVarArg)
        Observable.combineLatest(service.rx_getNotes(predicate: predicate), service.rx_getParameters)
            .bind { [weak self] notes, parameters in
                guard let parameters, !parameters.isEmpty else { return } // suggest to add trecking parameters

                guard let note = notes?.first,
                      let measurements = note.noteMeasure?.allObjects as? [Measurement]  else {
                    self?.createNote(parameters)
                    return
                }

                self?.mapMeasurements(note, measurements, parameters)
            }
            .disposed(by: disposeBag)
    }

    func createNote(_ parameters: [Parameter]) {
        service.addNote { note in
            note.date = Date()
        }
        .bind { [weak self] note in
            self?.mapMeasurements(note, [], parameters)
        }
        .disposed(by: disposeBag)
    }

    func createMeasurement(_ note: Note, _ parameter: Parameter) {
        service.addMeasurement { measurement in
            measurement.value = 0
            measurement.time = Date()
            measurement.measureParameter = parameter
            measurement.measureNote = note
        }
        .bind { [weak self] measurement in
            self?.showEditDialog(note, measurement, parameter)
        }
        .disposed(by: disposeBag)
    }

    func updateNote() {
        service.updateNote()
            .bind { [weak self] in
                self?.setup()
            }
            .disposed(by: disposeBag)
    }

    func mapMeasurements(_ note: Note, _ measurements: [Measurement], _ expectedParameters: [Parameter]) {
        propsRelay.mutate {
            $0.items = TreckingParameter.allCases.map { parameter in
                let param = expectedParameters.first { $0.name == parameter.title }
                let measurement = measurements.first { $0.measureParameter?.name == parameter.title }
                let value = measurement?.value ?? -1
                return MeasurementCellViewModel(
                    props: .init(
                        positionPercent: parameter.positionPercent,
                        measurement: .init(
                            isHidden: param == nil,
                            title: value != -1 ? "\(value) см" : parameter.title,
                            subTitle: value != -1 ? parameter.title : R.string.localizable.measurementEmpty(),
                            onTap: Command { [weak self] in
                                guard let self, let param else { return }
                                if let measurement {
                                    self.showEditDialog(note, measurement, param)
                                } else {
                                    self.createMeasurement(note, param)
                                }
                            }
                        )
                    )
                )
            }
        }
    }

    func showEditDialog(_ note: Note, _ measurement: Measurement, _ parameter: Parameter) {
        let editDialog = with(DialogController()) {
            $0.props = $0.props.mutate {
                $0.title = measurement.measureParameter?.name ?? ""
                $0.value = measurement.value
                $0.measure = .sm
                $0.onSave = CommandWith { [weak self] value in
                    guard let self, let value else { return }
                    measurement.value = value
                    self.updateNote()
                }
            }
        }
        router.showDialog(editDialog)
    }
}
