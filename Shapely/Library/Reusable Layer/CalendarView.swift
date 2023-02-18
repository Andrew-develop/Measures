//
//  CalendarView.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import UIKit
import SnapKit

final class CalendarView: UIView {

    private let toolbar = with(UIToolbar()) {
        $0.apply(.primary)
    }

    private let doneButton = with(UIButton()) {
        $0.apply(.doneButton)
    }

    private let calendarView = with(UICalendarView()) {
        $0.apply(.primary)
    }

    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        prepareView()
    }

    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CalendarView {
    func prepareView() {
        (self as UIView).apply(.backgroundColor)

        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection

        doneButton.addTarget(self, action: #selector(onDone), for: .touchUpInside)

        let doneButton = UIBarButtonItem(customView: doneButton)
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        toolbar.setItems([ spaceButton, doneButton], animated: false)

        addSubviews(toolbar, calendarView)
        makeConstraints()
    }

    func makeConstraints() {
        toolbar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Grid.ml.offset)
        }

        calendarView.snp.makeConstraints {
            $0.top.equalTo(toolbar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func render(oldProps: Props, newProps: Props) {
        if oldProps.selectedDate != newProps.selectedDate, let selectedDate = newProps.selectedDate {
            let selection = UICalendarSelectionSingleDate(delegate: self)
            selection.setSelected(selectedDate, animated: true)
            calendarView.selectionBehavior = selection
        }
    }

    @objc func onDone() {
        props.onDone.execute()
    }
}

extension CalendarView: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        props.onSelect.execute(with: dateComponents)
    }

    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
}

extension CalendarView {
    struct Props: Mutable, Equatable {
        var selectedDate: DateComponents?
        var onSelect: CommandWith<DateComponents?>
        var onDone: Command

        static var `default` = Props(selectedDate: nil, onSelect: .empty, onDone: .empty)

        static func == (lhs: CalendarView.Props, rhs: CalendarView.Props) -> Bool {
            lhs.selectedDate == rhs.selectedDate
        }
    }
}
