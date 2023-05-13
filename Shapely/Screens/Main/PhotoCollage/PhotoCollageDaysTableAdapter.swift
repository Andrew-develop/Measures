//
//  PhotoCollageDaysTableAdapter.swift
//  Shapely
//
//  Created by Andrew on 13.05.2023.
//

import UIKit

final class PhotoCollageDaysTableAdapter: NSObject {

    // MARK: - Properties

    private var diffableDataSource: UITableViewDiffableDataSource<Int, AnyHashable>?

    var category: [AnyHashable] = [] {
        didSet {
            updateSnapshot()
        }
    }

    func makeDiffableDataSource(_ table: UITableView) {
        diffableDataSource = UITableViewDiffableDataSource<Int, AnyHashable>(tableView: table) {
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
        var snapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        snapshot.appendSections([0])
        snapshot.appendItems(category, toSection: 0)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
