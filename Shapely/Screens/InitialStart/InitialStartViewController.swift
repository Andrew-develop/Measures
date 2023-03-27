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
        $0.register(InitialStartTextCell.self, forCellReuseIdentifier: InitialStartTextCell.className)
        $0.register(InitialStartPictureCell.self, forCellReuseIdentifier: InitialStartPictureCell.className)
        $0.register(InitialStartTitleCell.self, forCellReuseIdentifier: InitialStartTitleCell.className)
        $0.register(InitialStartDataCell.self, forCellReuseIdentifier: InitialStartDataCell.className)
        $0.register(InitialStartSegmentCell.self, forCellReuseIdentifier: InitialStartSegmentCell.className)
        $0.register(InitialStartParameterCell.self, forCellReuseIdentifier: InitialStartParameterCell.className)
        $0.register(InitialStartEditCell.self, forCellReuseIdentifier: InitialStartEditCell.className)
        $0.register(InitialStartTapeCell.self, forCellReuseIdentifier: InitialStartTapeCell.className)
    }

    private let titleLabel = with(UILabel()) {
        $0.apply(.screenTitle)
    }

    private let confirmView = ConfirmView()

    private let calendarView = CalendarView()

    var disposeBag = DisposeBag()
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
}

private extension InitialStartViewController {
    func prepareView() {
        view.apply(.backgroundColor)
        view.addSubviews(titleLabel, tableView, calendarView, confirmView)
        makeConstraints()
        hideCalendar()
    }

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

        if oldProps.pack.keys != newProps.pack.keys {
            showAnimation()
        }

        if let confirmProps = newProps.confirmProps {
            confirmView.props = confirmProps
        }

        if oldProps.calendarProps != newProps.calendarProps, let calendarProps = newProps.calendarProps {
            calendarView.props = calendarProps
        }

        if oldProps.isNeedCalendar != newProps.isNeedCalendar {
            if newProps.isNeedCalendar {
                showCalendar()
            } else {
                hideCalendar()
            }
        }
    }

    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.bottom.equalTo(confirmView.snp.top).offset(-Grid.s.offset)
        }

        calendarView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.4)
        }
    }

    func hideCalendar() {
        calendarView.isHidden = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.confirmView.snp.remakeConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
                $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
                $0.height.equalTo(56.0)
            }
            self.view.layoutIfNeeded()
        }
    }

    func showCalendar() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.confirmView.snp.remakeConstraints {
                $0.bottom.equalTo(self.calendarView.snp.top).offset(-Grid.sm.offset)
                $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
                $0.height.equalTo(56.0)
            }
            self.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.calendarView.isHidden = false
        }
    }

    func showAnimation() {
        view.alpha = 0
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.view.alpha = 1.0
        }
    }
}

extension InitialStartViewController {
    struct Props: Mutable {
        var title: String
        var pack: [InitialStartSection: [AnyHashable]]
        var calendarProps: CalendarView.Props?
        var confirmProps: ConfirmView.Props?
        var isNeedCalendar: Bool

        static var `default` = Props(title: "", pack: [:], calendarProps: nil,
                                     confirmProps: nil, isNeedCalendar: false)
    }
}
