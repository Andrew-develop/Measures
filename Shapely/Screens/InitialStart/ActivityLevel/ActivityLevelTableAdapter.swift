//
//  ActivityLevelTableAdapter.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import UIKit

final class ActivityLevelTableAdapter: NSObject {
    // MARK: - Properties

    var items: [ActivityLevelInfoCellViewModel] = []
}

// MARK: - UITableViewDataSource

extension ActivityLevelTableAdapter: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: items[indexPath.row].cellId, for: indexPath)
        if let reusableCell = cell as? PreparableTableCell {
            reusableCell.prepare(withViewModel: items[indexPath.row])
        }
        return cell
    }
}
