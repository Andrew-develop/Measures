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
    private let tableAdapter: ChartTableAdapter

    private let chartView = with(LineChartView()) {
        $0.isHidden = false
        $0.xAxis.axisMinimum = 1
        $0.xAxis.axisMaximum = 5
        $0.xAxis.granularity = 1
    }

    var disposeBag = DisposeBag()
    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    init(tableAdapter: ChartTableAdapter) {
        self.tableAdapter = tableAdapter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
}

private extension ChartViewController {
    func prepareView() {
        view.apply(.backgroundColor)
        view.addSubview(chartView)
        makeConstraints()
    }

    func makeConstraints() {
        chartView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
        }
    }

    func render(oldProps: Props, newProps: Props) {
        if oldProps.data != newProps.data, let data = newProps.data {
            chartView.data = data
        }
    }
}

extension ChartViewController {
    struct Props: Mutable {
        var data: ChartData?

        static var `default` = Props(data: nil)
    }
}
