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

    private var diffableDataSource: UITableViewDiffableDataSource<Int, InitialStartPackItem>?

    var item: InitialStartPack? {
        didSet {
            updateSnapshot()
        }
    }

    func makeDiffableDataSource(_ table: UITableView) {
        diffableDataSource = UITableViewDiffableDataSource<Int, InitialStartPackItem>(tableView: table) {
            tableView, indexPath, itemIdentifier in

            let model: PreparableViewModel

            switch itemIdentifier {
            case let .text(textModel):
                model = textModel
            case let .picture(pictureModel):
                model = pictureModel
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
        var snapshot = NSDiffableDataSourceSnapshot<Int, InitialStartPackItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(item.viewModels, toSection: 0)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate

extension InitialStartTableAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = item else { return UIView() }

        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: item.header.cellId)
        if let reusableHeader = header as? PreparableHeaderTableCell {
            reusableHeader.prepare(withViewModel: item.header)
        }
        return header
    }
}
