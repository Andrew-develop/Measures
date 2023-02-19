//
//  ActivityLevelViewController.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import UIKit
import SnapKit
import RxSwift

final class ActivityLevelViewController: UIViewController, PropsConsumer {
    private let tableAdapter: ActivityLevelTableAdapter

    private lazy var tableView = with(UITableView()) {
        $0.apply(.primary)
        $0.dataSource = tableAdapter
        $0.register(ActivityLevelInfoCell.self, forCellReuseIdentifier: ActivityLevelInfoCell.className)
    }

    private lazy var closeButton = with(UIButton()) {
        $0.apply(.closeButton)
    }

    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    init(tableAdapter: ActivityLevelTableAdapter) {
        self.tableAdapter = tableAdapter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()

        closeButton.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(navigationItem)
        navigationItem.title = R.string.localizable.activityLevelTitle()
        navigationController?.navigationBar.apply(.title(DefaultColorPalette.background,
                                                         font: DefaultTypography.body1))
    }

    private func prepareView() {
        view.apply(.backgroundColor)
        view.addSubviews(tableView)
        makeConstraints()
    }

    private func makeConstraints() {
        tableView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.bottom.equalToSuperview()
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        tableAdapter.items = newProps.items
        tableView.reloadData()
    }

    @objc private func onClose() {
        props.onClose.execute()
    }
}

extension ActivityLevelViewController {
    struct Props: Mutable {
        var items: [ActivityLevelInfoCellViewModel]
        var onClose: Command

        static var `default` = Props(items: [], onClose: .empty)
    }
}
