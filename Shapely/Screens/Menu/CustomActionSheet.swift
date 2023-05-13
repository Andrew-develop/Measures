//
//  CustomActionSheet.swift
//  UIComponents
//
//  Created by snn on 12.06.2021.
//

import UIKit
import SnapKit

final class CustomActionSheet: UIView {
    private let tableView = with(UITableView()) {
        $0.backgroundColor = .black
        $0.separatorInset = .zero
        $0.rowHeight = 51
        $0.layer.cornerRadius = Grid.xs.offset
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "CustomActionSheetCell")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = Grid.xs.offset
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 10

        tableView.delegate = self
        tableView.dataSource = self

        addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var dismiss: CommandWith<(() -> Void)?> = .empty

    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.items != newProps.items {
            tableView.reloadData()
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let height: CGFloat = props.items.reduce(0) { result, items in
            return result + CGFloat(items.count) * self.tableView.rowHeight + Grid.xs.offset
        }
        return CGSize(width: size.width, height: min(height - Grid.xs.offset, size.height))
    }

    struct Item: Equatable {
        let title: String
        let action: (() -> Void)?
        let image: UIImage?

        init(title: String, image: UIImage?, action: (() -> Void)?) {
            self.title = title
            self.action = action
            self.image = image
        }

        static func == (lhs: CustomActionSheet.Item, rhs: CustomActionSheet.Item) -> Bool {
            lhs.title == rhs.title
        }
    }
}

extension CustomActionSheet: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return props.items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.items[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomActionSheetCell", for: indexPath)

        cell.textLabel?.text = props.items[indexPath.section][indexPath.row].title
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.imageView?.image = props.items[indexPath.section][indexPath.row].image

        return cell
    }
}

extension CustomActionSheet: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss.execute(with: props.items[indexPath.section][indexPath.row].action)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return props.items.count - 1 == section ? 0 : Grid.xs.offset
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension CustomActionSheet {
    struct Props: Mutable {
        var items: [[Item]]

        static var `default` = Props(items: [])
    }
}
