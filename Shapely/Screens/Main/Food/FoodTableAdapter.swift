//
//  FoodTableAdapter.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import UIKit

final class FoodTableAdapter: NSObject {
    // MARK: - Properties

    var items: [String] = []
}

// MARK: - UITableViewDataSource

extension FoodTableAdapter: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        1
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension FoodTableAdapter: UITableViewDelegate {}
