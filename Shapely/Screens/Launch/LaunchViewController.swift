//
//  LaunchViewController.swift
//  Shapely
//
//  Created by Andrew on 12.02.2023.
//

import UIKit
import SnapKit
import RxSwift

final class LaunchViewController: UIViewController, PropsConsumer {
    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func prepareView() {
        makeConstraints()
        view.apply(.backgroundColor)
    }

    private func makeConstraints() {}

    private func render(oldProps: Props, newProps: Props) {}
}

extension LaunchViewController {
    struct Props: Mutable {
        // var <#name#>: <#type#>

        static var `default` = Props()
    }
}
