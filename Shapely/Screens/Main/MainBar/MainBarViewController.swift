//
//  MainBarViewController.swift
//  Vladlink
//
//  Created by Pavel on 13/03/2021.
//  Copyright © 2021 Vladlink. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit

final class MainBarViewController: UITabBarController {
    // MARK: - Properties

    private let factory: MainBarViewFactory

    // MARK: - Lifecycle

    init(factory: MainBarViewFactory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .always
    }

    // MARK: - Prepare View

    private func prepareView() {
        delegate = self
        view.apply(.backgroundColor)
        let tabs: [MainTabBarItem] = MainTabBarItem.allCases
        let viewControllers = tabs.map { factory.createViewControllerItem($0) }
        self.viewControllers = viewControllers
        setTabBarAppearance()
    }

    private func setTabBarAppearance() {
        let width = CGFloat(MainTabBarItem.allCases.count) * Grid.l.offset + Grid.m.offset
        let height = Grid.xxl.offset

        let roundLayer = CAShapeLayer()

        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: (tabBar.bounds.width - width) / 2,
                y: (tabBar.bounds.height - height) / 2,
                width: width,
                height: height
            ),
            cornerRadius: Grid.s.offset
        )

        roundLayer.path = bezierPath.cgPath

        tabBar.layer.insertSublayer(roundLayer, at: 0)

        tabBar.itemWidth = Grid.l.offset
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = Grid.xs.offset / 2

        roundLayer.fillColor = DefaultColorPalette.button.cgColor

        tabBar.tintColor = DefaultColorPalette.text
        tabBar.unselectedItemTintColor = DefaultColorPalette.text
    }
}

extension MainBarViewController: UITabBarControllerDelegate {
    func tabBarController(_: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let itemTag = viewController.tabBarItem.tag
        guard MainTabBarItem(rawValue: itemTag) != nil else {
            return false
        }
        return true
    }
}
