//
//  InitialStartViewController.swift
//  Shapely
//
//  Created by Andrew on 15.02.2023.
//

import UIKit
import SnapKit
import RxSwift

final class InitialStartViewController: InitialViewController, PropsConsumer {

    private let tableAdapter: InitialStartTableAdapter

    var disposeBag = DisposeBag()
    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    init(tableAdapter: InitialStartTableAdapter) {
        self.tableAdapter = tableAdapter
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableAdapter.makeDiffableDataSource(tableView)
    }
}

private extension InitialStartViewController {
    func render(oldProps: Props, newProps: Props) {
        tableAdapter.pack = newProps.pack

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

        if let confirmProps = newProps.confirmProps {
            confirmView.props = confirmProps
        }
    }
}

extension InitialStartViewController {
    struct Props: Mutable {
        var title: String
        var pack: [InitialStartSection.Start: [AnyHashable]]
        var confirmProps: ConfirmView.Props?

        static var `default` = Props(title: "", pack: [:], confirmProps: nil)
    }
}
