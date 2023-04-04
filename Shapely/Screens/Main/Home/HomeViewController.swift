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
        $0.dragDelegate = tableAdapter
        $0.dropDelegate = tableAdapter
        $0.register(CaloriesCell.self, forCellReuseIdentifier: CaloriesCell.className)
        $0.register(AddWidgetCell.self, forCellReuseIdentifier: AddWidgetCell.className)
        $0.register(PhotoProgressCell.self, forCellReuseIdentifier: PhotoProgressCell.className)
        $0.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.className)
    }

    private let titleLabel = with(UILabel()) {
        $0.apply(.screenTitle)
    }

    private let controlButton = with(UIButton()) {
        $0.apply(.controlButton)
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
        view.addSubviews(titleLabel, controlButton, tableView)

        controlButton.addTarget(self, action: #selector(onTap), for: .touchUpInside)

        makeConstraints()
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(Grid.s.offset)
            $0.trailing.equalTo(controlButton.snp.leading).offset(-Grid.xs.offset)
        }

        controlButton.snp.makeConstraints {
            $0.bottom.equalTo(titleLabel.snp.bottom)
            $0.trailing.equalToSuperview().offset(-Grid.s.offset)
            $0.size.equalTo(CGSize(width: Grid.sm.offset, height: Grid.sm.offset))
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Grid.s.offset)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.bottom.equalToSuperview()
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        tableAdapter.widgets = newProps.widgets

        if oldProps.title != newProps.title {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.03
            titleLabel.attributedText = NSMutableAttributedString(
                string: newProps.title,
                attributes: [
                    NSAttributedString.Key.kern: -0.41,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
            )
        }
    }

    @objc private func onTap() {
        tableView.dragInteractionEnabled = true
        props.onTap.execute()
    }
}

extension HomeViewController {
    struct Props: Mutable {
        var title: String
        var widgets: [WidgetType: [AnyHashable]]
        var onTap: Command

        static var `default` = Props(title: "", widgets: [:], onTap: .empty)
    }
}
