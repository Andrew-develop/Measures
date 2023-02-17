//
//  UITableViewStyle.swift
//  Vladlink
//
//  Created by Pavel Zorin on 07.03.2021.
//

import UIKit

extension StyleWrapper where Element == UITableView {
    static var primary: StyleWrapper {
        return .wrap { table, theme in
            (table as UIView).apply(.backgroundColor)
            table.separatorStyle = .none
            table.rowHeight = UITableView.automaticDimension
            table.showsVerticalScrollIndicator = false
            table.backgroundColor = theme.colorPalette.background
            if #available(iOS 15, *) {
                table.sectionHeaderTopPadding = 0
            }
        }
    }
}
