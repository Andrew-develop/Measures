//
//  PhotoCollageViewController.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import UIKit
import SnapKit
import RxSwift

final class PhotoCollageViewController: UIViewController, PropsConsumer {
    private let tableAdapter: PhotoCollageTableAdapter

    private lazy var tableView = with(UITableView()) {
        $0.apply(.primary)
        $0.register(InitialStartTitleCell.self, forCellReuseIdentifier: InitialStartTitleCell.className)
        $0.register(PhotoTypesCell.self, forCellReuseIdentifier: PhotoTypesCell.className)
        $0.register(AddWidgetCell.self, forCellReuseIdentifier: AddWidgetCell.className)
    }

    private let titleLabel = with(UILabel()) {
        $0.apply(.screenTitle)
    }

    var disposeBag = DisposeBag()
    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    init(tableAdapter: PhotoCollageTableAdapter) {
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
        view.addSubviews(titleLabel, tableView)

        makeConstraints()
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.bottom.equalToSuperview()
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        tableAdapter.category = newProps.category

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
}

extension PhotoCollageViewController {
    struct Props: Mutable {
        var title: String
        var category: [Angel: [AnyHashable]]

        static var `default` = Props(title: "", category: [:])
    }
}
