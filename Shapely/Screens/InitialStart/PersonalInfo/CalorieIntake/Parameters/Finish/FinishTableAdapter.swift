//
//  FinishTableAdapter.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import UIKit

final class FinishTableAdapter: NSObject {

    // MARK: - Properties

    private var diffableDataSource: UITableViewDiffableDataSource<InitialStartSection.Finish, AnyHashable>?

    var pack: [InitialStartSection.Finish: [AnyHashable]] = [:] {
        didSet {
            updateSnapshot()
        }
    }

    func makeDiffableDataSource(_ table: UITableView) {
        diffableDataSource = UITableViewDiffableDataSource<InitialStartSection.Finish, AnyHashable>(tableView: table) {
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
        var snapshot = NSDiffableDataSourceSnapshot<InitialStartSection.Finish, AnyHashable>()
        snapshot.appendSections(InitialStartSection.Finish.allCases)
        pack.forEach {
            snapshot.appendItems($0.value, toSection: $0.key)
        }
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
