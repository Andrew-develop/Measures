//
//  ActivityLevelTableAdapter.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import UIKit

final class ActivityLevelTableAdapter: NSObject {
    // MARK: - Properties

    var items: [ActivityLevelInfoCellViewModel] = [] {
        didSet {
            updateSnapshot()
        }
    }

    private var diffableDataSource: UITableViewDiffableDataSource<Int, ActivityLevelInfoCellViewModel>?

    func makeDiffableDataSource(_ table: UITableView) {
        diffableDataSource = UITableViewDiffableDataSource<Int, ActivityLevelInfoCellViewModel>(tableView: table) {
            tableView, indexPath, itemIdentifier in

            let cell = tableView.dequeueReusableCell(withIdentifier: itemIdentifier.cellId, for: indexPath)
            if let reusableCell = cell as? PreparableTableCell {
                reusableCell.prepare(withViewModel: itemIdentifier)
            }
            return cell
        }
        updateSnapshot()
    }

    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ActivityLevelInfoCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
