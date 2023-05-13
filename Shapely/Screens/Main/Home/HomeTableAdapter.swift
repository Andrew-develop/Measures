//
//  HomeTableAdapter.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit

final class HomeDiffableDataSource: UITableViewDiffableDataSource<WidgetType, AnyHashable> {

    var canMoveRow = false

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        canMoveRow
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let sectionFrom = sectionIdentifier(for: sourceIndexPath.section),
              let itemFrom = itemIdentifier(for: sourceIndexPath),
              let sectionTo = sectionIdentifier(for: destinationIndexPath.section),
              sourceIndexPath != destinationIndexPath else { return }

        var snap = snapshot()
        snap.deleteSections([sectionFrom])

        let isAfter = destinationIndexPath.section > sourceIndexPath.section

        if isAfter {
            snap.insertSections([sectionFrom], afterSection: sectionTo)
        } else {
            snap.insertSections([sectionFrom], beforeSection: sectionTo)
        }

        snap.appendItems([itemFrom], toSection: sectionFrom)

        apply(snap, animatingDifferences: false)
    }
}

final class HomeTableAdapter: NSObject {

    // MARK: - Properties

    private var diffableDataSource: HomeDiffableDataSource?

    var canMoveRow = false {
        didSet {
            diffableDataSource?.canMoveRow = canMoveRow
        }
    }

    var widgets: [WidgetType: [AnyHashable]] = [:] {
        didSet {
            updateSnapshot()
        }
    }

    func makeDiffableDataSource(_ table: UITableView) {
        diffableDataSource = HomeDiffableDataSource(tableView: table) {
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

extension HomeTableAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        IndexPath(row: 0, section: proposedDestinationIndexPath.section)
    }
}

extension HomeTableAdapter: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        []
    }
}

extension HomeTableAdapter: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
