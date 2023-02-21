//
//  IntercomTableAdapter.swift
//  Vladlink
//
//  Created by Pavel on 13/03/2021.
//  Copyright © 2021 Vladlink. All rights reserved.
//

import UIKit

final class InitialStartTableAdapter: NSObject {

    enum Section: Int {
        case start
        case personalInfo
        case caloryIntake
        case parameters
        case finish
    }

    // MARK: - Properties

    private var diffableDataSource: UITableViewDiffableDataSource<Section, InitialStartPackItem>?

    var item: (Section, InitialStartPack)? {
        didSet {
            updateSnapshot()
        }
    }

    func makeDiffableDataSource(_ table: UITableView) {
        diffableDataSource = UITableViewDiffableDataSource<Section, InitialStartPackItem>(tableView: table) {
            tableView, indexPath, itemIdentifier in

            let model: PreparableViewModel

            switch itemIdentifier {
            case let .text(textModel):
                model = textModel
            case let .picture(pictureModel):
                model = pictureModel
            case let .segment(segmentModel):
                model = segmentModel
            case let .title(titleModel):
                model = titleModel
            case let .data(dataModel):
                model = dataModel
            case let .parameter(parameterModel):
                model = parameterModel
            case let .edit(editModel):
                model = editModel
            case let .tape(tapeModel):
                model = tapeModel
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, InitialStartPackItem>()
        snapshot.appendSections([item.0])
        snapshot.appendItems(item.1.viewModels, toSection: item.0)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate

extension InitialStartTableAdapter: UITableViewDelegate {
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
