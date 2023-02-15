import SafariServices
import UIKit

protocol AppRouter: Presentable {
    func present(_ module: Presentable?, animated: Bool)

    func pushToRoot(_ module: Presentable, animated: Bool)
    func push(_ module: Presentable?, animated: Bool)

    func popModule(animated: Bool)

    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func dismissFrontModule(animated: Bool, completion: (() -> Void)?)

    func setRootModule(_ module: Presentable?, animated: Bool)
    func popToRootModule(animated: Bool)
}

extension AppRouter {
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }

    func dismissFrontModule() {
        dismissFrontModule(animated: true, completion: nil)
    }

    func present(_ module: Presentable?) {
        present(module, animated: true)
    }

    func push(_ module: Presentable?) {
        push(module, animated: true)
    }

    func pushToRoot(_ module: Presentable) {
        pushToRoot(module, animated: true)
    }

    func popModule() {
        popModule(animated: true)
    }
}
