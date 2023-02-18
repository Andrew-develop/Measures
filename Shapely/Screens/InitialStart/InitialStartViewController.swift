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
        $0.register(InitialStartTitleCell.self, forCellReuseIdentifier: InitialStartTitleCell.className)
        $0.register(InitialStartDataCell.self, forCellReuseIdentifier: InitialStartDataCell.className)
        $0.register(InitialStartSegmentCell.self, forCellReuseIdentifier: InitialStartSegmentCell.className)
        $0.register(
            MainHeaderCell.self, forHeaderFooterViewReuseIdentifier: MainHeaderCell.className
        )
    }

    private let confirmView = ConfirmView()

    private let calendarView = CalendarView()

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
        view.addSubviews(tableView, calendarView, confirmView)
        setBaseConstraints()
    }

    func render(oldProps: Props, newProps: Props) {
        tableAdapter.item = newProps.pack
        if oldProps.confirmProps != newProps.confirmProps, let confirmProps = newProps.confirmProps {
            confirmView.props = confirmProps
        }

        if oldProps.calendarProps != newProps.calendarProps, let calendarProps = newProps.calendarProps {
            calendarView.props = calendarProps
        }

        if oldProps.isNeedCalendar != newProps.isNeedCalendar {
            if newProps.isNeedCalendar {
                setCalendarConstraints()
            } else {
                setBaseConstraints()
            }
        }
    }

    func setBaseConstraints() {
        tableView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.bottom.equalToSuperview()
        }

        confirmView.snp.remakeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.height.equalTo(56.0)
        }

        calendarView.isHidden = true
    }

    func setCalendarConstraints() {
        calendarView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.4)
        }

        confirmView.snp.remakeConstraints {
            $0.bottom.equalTo(calendarView.snp.top).offset(-Grid.sm.offset)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.height.equalTo(56.0)
        }

        tableView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.bottom.equalTo(confirmView.snp.top).offset(-Grid.sm.offset)
        }

        calendarView.isHidden = false
    }
}

extension InitialStartViewController {
    struct Props: Mutable {
        var pack: (InitialStartTableAdapter.Section, InitialStartPack)?
        var calendarProps: CalendarView.Props?
        var confirmProps: ConfirmView.Props?
        var isNeedCalendar: Bool

        static var `default` = Props(pack: nil, calendarProps: nil, confirmProps: nil, isNeedCalendar: false)
    }
}
