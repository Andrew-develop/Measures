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
        makeConstraints()
    }

    func makeConstraints() {}

    func render(oldProps: Props, newProps: Props) {}
}

extension ChartViewController {
    struct Props: Mutable {
        // var <#name#>: <#type#>

        static var `default` = Props()
    }
}
