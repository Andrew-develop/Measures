//
//  CalorieIntakeTableAdapter.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import UIKit

final class CalorieIntakeTableAdapter: NSObject {

    // MARK: - Properties

    private var diffableDataSource: UITableViewDiffableDataSource<InitialStartSection.CalorieIntake, AnyHashable>?

    var pack: [InitialStartSection.CalorieIntake: [AnyHashable]] = [:] {
        didSet {
            updateSnapshot()
        }
    }

    func makeDiffableDataSource(_ table: UITableView) {
        diffableDataSource = UITableViewDiffableDataSource
        <InitialStartSection.CalorieIntake, AnyHashable>(tableView: table) {
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
        var snapshot = NSDiffableDataSourceSnapshot<InitialStartSection.CalorieIntake, AnyHashable>()
        snapshot.appendSections(InitialStartSection.CalorieIntake.allCases)
        pack.forEach {
            snapshot.appendItems($0.value, toSection: $0.key)
        }
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
