//
//  InitialViewController.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import UIKit

class InitialViewController: UIViewController {

    lazy var tableView = with(UITableView()) {
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

    let titleLabel = with(UILabel()) {
        $0.apply(.screenTitle)
    }

    let confirmView = ConfirmView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.view.alpha = 1.0
            self?.confirmView.animate()
            self?.confirmView.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.confirmView.prepareAfterAnimation()
        }
    }
}

private extension InitialViewController {
    func prepareView() {
        view.apply(.backgroundColor)
        view.addSubviews(titleLabel, tableView, confirmView)
        makeConstraints()
    }

    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
        }

        confirmView.snp.remakeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.height.equalTo(56.0)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
            $0.bottom.equalTo(confirmView.snp.top).offset(-Grid.s.offset)
        }
    }
}
