//
//  HomeViewController.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit
import SnapKit
import RxSwift

final class HomeViewController: UIViewController, PropsConsumer {
    private let tableAdapter: HomeTableAdapter

    private lazy var tableView = with(UITableView()) {
        $0.apply(.primary)
        $0.delegate = tableAdapter
        $0.register(CaloriesCell.self, forCellReuseIdentifier: CaloriesCell.className)
        $0.register(AddWidgetCell.self, forCellReuseIdentifier: AddWidgetCell.className)
        $0.register(
            MainControlHeaderCell.self, forHeaderFooterViewReuseIdentifier: MainControlHeaderCell.className
        )
    }

    var disposeBag = DisposeBag()
    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    init(tableAdapter: HomeTableAdapter) {
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
        view.addSubview(tableView)
        makeConstraints()
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.bottom.equalToSuperview()
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        tableAdapter.item = newProps.pack
    }
}

extension HomeViewController {
    struct Props: Mutable {
        var pack: (HomeTableAdapter.Section, WidgetInfoPack)?

        static var `default` = Props(pack: nil)
    }
}
