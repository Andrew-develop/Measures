//
//  HomeTableAdapter.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit

final class HomeTableAdapter: NSObject {

    // MARK: - Properties

    private var diffableDataSource: UITableViewDiffableDataSource<WidgetType, AnyHashable>?

    var widgets: [WidgetType: [AnyHashable]] = [:] {
        didSet {
            updateSnapshot()
        }
    }

    func makeDiffableDataSource(_ table: UITableView) {
        diffableDataSource = UITableViewDiffableDataSource<WidgetType, AnyHashable>(tableView: table) {
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
        var snapshot = NSDiffableDataSourceSnapshot<WidgetType, AnyHashable>()
        snapshot.appendSections(WidgetType.allCases)
        widgets.forEach {
            snapshot.appendItems($0.value, toSection: $0.key)
        }
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
