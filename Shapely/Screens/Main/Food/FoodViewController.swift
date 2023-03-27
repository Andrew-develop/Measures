//
//  FoodViewController.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import UIKit
import SnapKit
import RxSwift

final class FoodViewController: UIViewController, PropsConsumer {
    private let tableAdapter: FoodTableAdapter

    var disposeBag = DisposeBag()
    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    init(tableAdapter: FoodTableAdapter) {
        self.tableAdapter = tableAdapter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    private func prepareView() {
        makeConstraints()
    }

    private func makeConstraints() {}

    private func render(oldProps: Props, newProps: Props) {}
}

extension FoodViewController {
    struct Props: Mutable {
        // var <#name#>: <#type#>

        static var `default` = Props()
    }
}
