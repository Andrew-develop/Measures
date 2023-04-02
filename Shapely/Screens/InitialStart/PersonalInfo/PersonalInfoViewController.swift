//
//  PersonalInfoViewController.swift
//  Shapely
//
//  Created by Andrew on 31.03.2023.
//

import UIKit
import SnapKit
import RxSwift

final class PersonalInfoViewController: InitialViewController, PropsConsumer {

    private let tableAdapter: PersonalInfoTableAdapter

    private let calendarView = CalendarView()

    var disposeBag = DisposeBag()
    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    init(tableAdapter: PersonalInfoTableAdapter) {
        self.tableAdapter = tableAdapter
        super.init()
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

private extension PersonalInfoViewController {
    func prepareView() {
        view.addSubview(calendarView)

        calendarView.isHidden = true

        makeConstraints()
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
        calendarView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.4)
        }

        confirmView.snp.remakeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.height.equalTo(56.0)
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
}

extension PersonalInfoViewController {
    struct Props: Mutable {
        var title: String
        var pack: [InitialStartSection.PersonalInfo: [AnyHashable]]
        var calendarProps: CalendarView.Props?
        var confirmProps: ConfirmView.Props?
        var isNeedCalendar: Bool

        static var `default` = Props(title: "", pack: [:], calendarProps: nil,
                                     confirmProps: nil, isNeedCalendar: false)
    }
}
