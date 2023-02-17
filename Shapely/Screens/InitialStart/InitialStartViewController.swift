//
//  InitialStartViewController.swift
//  Shapely
//
//  Created by Andrew on 15.02.2023.
//

import UIKit
import SnapKit
import RxSwift

final class InitialStartViewController: UIViewController, PropsConsumer {

    private let tableAdapter: InitialStartTableAdapter

    private lazy var tableView = with(UITableView()) {
        $0.apply(.primary)
        $0.delegate = tableAdapter
        $0.register(InitialStartTextCell.self, forCellReuseIdentifier: InitialStartTextCell.className)
        $0.register(InitialStartPictureCell.self, forCellReuseIdentifier: InitialStartPictureCell.className)
        $0.register(
            MainHeaderCell.self, forHeaderFooterViewReuseIdentifier: MainHeaderCell.className
        )
    }

    private let confirmView = ConfirmView()

    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    init(tableAdapter: InitialStartTableAdapter) {
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
        view.addSubviews(tableView, confirmView)
        makeConstraints()
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.bottom.equalToSuperview()
        }

        confirmView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.height.equalTo(56.0)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        tableAdapter.item = newProps.pack
        if oldProps.confirmProps != newProps.confirmProps, let confirmProps = newProps.confirmProps {
            confirmView.props = confirmProps
        }
    }
}

extension InitialStartViewController {
    struct Props: Mutable {
        var pack: InitialStartPack?
        var confirmProps: ConfirmView.Props?

        static var `default` = Props(pack: nil, confirmProps: nil)
    }
}
