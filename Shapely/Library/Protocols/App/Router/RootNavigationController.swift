//
//  RootNavigationController.swift
//  Vladlink
//
//  Created by Pavel Zorin on 22.02.2021.
//

import SnapKit
import UIKit

class RootNavigationController: UINavigationController {
    // MARK: - Properties

    private var rootViewController: UIViewController?

    init() {
        super.init(nibName: nil, bundle: nil)
        view.apply(.backgroundColor)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        rootViewController = topViewController

        makeConstraint()
    }

    private func makeConstraint() {}
}

// MARK: - UINavigationControllerDelegate

extension RootNavigationController: UINavigationControllerDelegate {
    func navigationController(_: UINavigationController, willShow viewController: UIViewController, animated _: Bool) {
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }

    func navigationController(_: UINavigationController, didShow _: UIViewController, animated _: Bool) {}
}
