//
//  ChartPresenter.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import RxSwift
import RxCocoa
import Charts

final class ChartPresenter: PropsProducer {
    typealias Props = ChartViewController.Props

    private let service: ChartServiceProvider
    private let router: ChartInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    init(service: ChartServiceProvider, router: ChartInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension ChartPresenter {
    func setup() {
        let dataEntries = [ChartDataEntry(x: 0, y: 76),
                           ChartDataEntry(x: 1, y: 75),
                           ChartDataEntry(x: 2, y: 76),
                           ChartDataEntry(x: 3, y: 76.5),
                           ChartDataEntry(x: 4, y: 77),
                           ChartDataEntry(x: 5, y: 75.5),
                           ChartDataEntry(x: 5, y: 74.5)]

        let set1 = LineChartDataSet(entries: dataEntries, label: "Изменение веса за неделю")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(DefaultColorPalette.button)
        set1.fillColor = DefaultColorPalette.button
        set1.fillAlpha = 0.5
        set1.drawFilledEnabled = true
        set1.drawVerticalHighlightIndicatorEnabled = false
        set1.drawVerticalHighlightIndicatorEnabled = false

        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)

        propsRelay.mutate {
            $0.data = data
        }
    }
}
