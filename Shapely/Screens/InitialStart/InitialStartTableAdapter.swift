//
//  IntercomTableAdapter.swift
//  Vladlink
//
//  Created by Pavel on 13/03/2021.
//  Copyright © 2021 Vladlink. All rights reserved.
//

import UIKit

final class InitialStartTableAdapter: NSObject {

    // MARK: - Properties

    private var diffableDataSource: UITableViewDiffableDataSource<InitialStartSection, AnyHashable>?

    var pack: [InitialStartSection: [AnyHashable]] = [:] {
        didSet {
            updateSnapshot()
        }
    }

    func makeDiffableDataSource(_ table: UITableView) {
        diffableDataSource = UITableViewDiffableDataSource<InitialStartSection, AnyHashable>(tableView: table) {
            tableView, indexPath, itemIdentifier in

            guard let model = itemIdentifier as? PreparableViewModel else { return UITableViewCell() }

            let cell = tableView.dequeueReusableCell(withIdentifier: model.cellId, for: indexPath)
            if let reusableCell = cell as? PreparableTableCell {
                reusableCell.prepare(withViewModel: model)
            }
            return cell
        }
        updateSnapshot()
    }

    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<InitialStartSection, AnyHashable>()
        snapshot.appendSections(InitialStartSection.allCases)
        pack.forEach {
            snapshot.appendItems($0.value, toSection: $0.key)
        }
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
