//
//  MeasurementTableAdapter.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import UIKit

final class MeasurementTableAdapter: NSObject {
    // MARK: - Properties

    private var diffableDataSource: UITableViewDiffableDataSource<Int, MeasurementCellViewModel>?

    var items: [MeasurementCellViewModel] = [] {
        didSet {
            updateSnapshot()
        }
    }

    func makeDiffableDataSource(_ table: UITableView) {
        diffableDataSource = UITableViewDiffableDataSource<Int, MeasurementCellViewModel>(tableView: table) {
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
        var snapshot = NSDiffableDataSourceSnapshot<Int, MeasurementCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
