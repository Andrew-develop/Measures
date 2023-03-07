//
//  HomeTableAdapter.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit

final class HomeTableAdapter: NSObject {
    enum Section: Int {
        case base
        case editing
    }

    // MARK: - Properties

    private var diffableDataSource: UITableViewDiffableDataSource<Section, WidgetInfoPackItem>?

    var item: (Section, WidgetInfoPack)? {
        didSet {
            updateSnapshot()
        }
    }

    func makeDiffableDataSource(_ table: UITableView) {
        diffableDataSource = UITableViewDiffableDataSource<Section, WidgetInfoPackItem>(tableView: table) {
            tableView, indexPath, itemIdentifier in

            let model: PreparableViewModel

            switch itemIdentifier {
            case let .calories(caloriesModel):
                model = caloriesModel
            case let .addWidget(addModel):
                model = addModel
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: model.cellId, for: indexPath)
            if let reusableCell = cell as? PreparableTableCell {
                reusableCell.prepare(withViewModel: model)
            }
            return cell
        }
        updateSnapshot()
    }

    private func updateSnapshot() {
        guard let item = item else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, WidgetInfoPackItem>()
        snapshot.appendSections([item.0])
        snapshot.appendItems(item.1.viewModels, toSection: item.0)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate

extension HomeTableAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = item else { return UIView() }

        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: item.1.header.cellId)
        if let reusableHeader = header as? PreparableHeaderTableCell {
            reusableHeader.prepare(withViewModel: item.1.header)
        }
        return header
    }
}
