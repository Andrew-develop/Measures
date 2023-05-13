//
//  ChartViewController.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import UIKit
import SnapKit
import RxSwift
import Charts

final class ChartViewController: UIViewController, PropsConsumer {
    private let chartView = with(LineChartView()) {
        $0.isHidden = false
        $0.rightAxis.enabled = false
        $0.leftAxis.enabled = false
        $0.drawBordersEnabled = false
        $0.xAxis.drawAxisLineEnabled = false
        $0.xAxis.drawGridLinesEnabled = false
        $0.leftAxis.drawAxisLineEnabled = false
        $0.xAxis.drawLabelsEnabled = false
        $0.legend.enabled = false
        $0.minOffset = 0
    }

    private let intervalSegment = with(UISegmentedControl()) {
        $0.apply(.interval)
    }

    var disposeBag = DisposeBag()
    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()

        navigationItem.title = "Калории"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: R.image.arrowLeft(), style: .plain, target: self, action: #selector(onBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = DefaultColorPalette.text
    }
}

private extension ChartViewController {
    func prepareView() {
        view.apply(.backgroundColor)
        view.addSubviews(chartView, intervalSegment)
        makeConstraints()
    }

    func makeConstraints() {
        chartView.snp.makeConstraints {
            $0.leading.trailing.centerY.equalToSuperview()
            $0.height.equalTo(300.0)
        }

        intervalSegment.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom).offset(Grid.s.offset)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
        }
    }

    func render(oldProps: Props, newProps: Props) {
        if oldProps.data != newProps.data, let data = newProps.data {
            chartView.data = data
        }

        if oldProps.selectedSegmentIndex != newProps.selectedSegmentIndex,
           let index = newProps.selectedSegmentIndex {
            intervalSegment.selectedSegmentIndex = index
        }
    }

    @objc private func onBack() {
        props.onBack.execute()
    }
}

extension ChartViewController {
    struct Props: Mutable {
        var selectedSegmentIndex: Int?
        var data: LineChartData?
        var onBack: Command

        static var `default` = Props(selectedSegmentIndex: nil, data: nil, onBack: .empty)
    }
}
