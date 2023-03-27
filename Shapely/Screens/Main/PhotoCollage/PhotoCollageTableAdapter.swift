//
//  PhotoCollageTableAdapter.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit

final class PhotoCollageTableAdapter: NSObject {

    // MARK: - Properties

    private var diffableDataSource: UITableViewDiffableDataSource<Angel, AnyHashable>?

    var category: [Angel: [AnyHashable]] = [:] {
        didSet {
            updateSnapshot()
        }
    }

    func makeDiffableDataSource(_ table: UITableView) {
        diffableDataSource = UITableViewDiffableDataSource<Angel, AnyHashable>(tableView: table) {
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
        var snapshot = NSDiffableDataSourceSnapshot<Angel, AnyHashable>()
        snapshot.appendSections(Angel.allCases)
        category.forEach {
            snapshot.appendItems($0.value, toSection: $0.key)
        }
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
