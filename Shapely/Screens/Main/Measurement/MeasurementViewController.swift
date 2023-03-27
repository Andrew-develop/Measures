//
//  MeasurementViewController.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import UIKit
import SnapKit
import RxSwift

final class MeasurementViewController: UIViewController, PropsConsumer {
    private let tableAdapter: MeasurementTableAdapter

    private let backImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleAspectFit)
        $0.image = R.image.body()
    }

    private lazy var tableView = with(UITableView()) {
        $0.apply(.parameters)
        $0.register(MeasurementCell.self, forCellReuseIdentifier: MeasurementCell.className)
    }

    var disposeBag = DisposeBag()
    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    init(tableAdapter: MeasurementTableAdapter) {
        self.tableAdapter = tableAdapter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()

        tableAdapter.makeDiffableDataSource(tableView)
    }

    private func prepareView() {
        view.apply(.backgroundColor)
        view.addSubviews(backImageView, tableView)
        makeConstraints()
    }

    private func makeConstraints() {
        backImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        tableAdapter.items = newProps.items
    }
}

extension MeasurementViewController {
    struct Props: Mutable {
        var items: [MeasurementCellViewModel]

        static var `default` = Props(items: [])
    }
}
