import IntentsUI
import RxSwift
import SafariServices
import UIKit

final class AppRouterImp: NSObject, AppRouter {
    private var rootController: UINavigationController?

    init(rootController: UINavigationController) {
        self.rootController = rootController
    }

    var rx_dismissed: Observable<Void> {
        return Observable.empty()
    }

    func toPresent() -> UIViewController? {
        return rootController
    }

    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }

        if let popoverController = controller.popoverPresentationController, let view = rootController?.view {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX,
                                                  y: view.bounds.midY,
                                                  width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        rootController?.presentAnyway(controller, animated: animated)
    }

    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }

    func dismissFrontModule(animated: Bool, completion: (() -> Void)?) {
        if rootController == rootController?.latestPresented {
            completion?()
            return
        }
        rootController?.latestPresented.dismiss(animated: animated, completion: completion)
    }

    func push(_ module: Presentable?, animated: Bool) {
        guard
            let controller = module?.toPresent(),
            controller is UINavigationController == false
        else { assertionFailure("Deprecated push UINavigationController."); return }

        guard let rootNavigation = rootController?.latestPresented as? UINavigationController else {
            assertionFailure("Latest controller isn't UINavigationController")
            return
        }

        rootNavigation.pushViewController(controller, animated: animated)
    }

    func pushToRoot(_ module: Presentable, animated: Bool) {
        guard let controller = module.toPresent() else {
            assertionFailure()
            return
        }

        rootController?.pushViewController(controller, animated: animated)
    }

    func popModule(animated: Bool) {
        guard let rootNavigation = rootController?.latestPresented as? UINavigationController else {
            assertionFailure("Latest controller isn't UINavigationController")
            return
        }

        rootNavigation.popViewController(animated: animated)
    }

    func setRootModule(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: animated)
    }

    func popToRootModule(animated: Bool) {
        guard let rootNavigation = rootController?.latestPresented as? UINavigationController else {
            assertionFailure("Latest controller isn't UINavigationController")
            return
        }

        rootNavigation.popToRootViewController(animated: animated)
    }
}

extension UIViewController {
    var latestPresented: UIViewController {
        if let presented = presentedViewController {
            return presented.latestPresented
        } else {
            return self
        }
    }

    final func presentAnyway(_ viewController: UIViewController, animated: Bool) {
        let navigationController = self as? UINavigationController

        if let presented = presentedViewController {
            presented.presentAnyway(viewController, animated: animated)
        } else if let alertController = viewController as? UIAlertController,
            let alertPresenter = (navigationController?.topViewController as? AlertPresenter) ??
            (self as? AlertPresenter) {
            alertPresenter.presentAlert(alertController, animated)
        } else {
            present(viewController, animated: animated, completion: nil)
        }
    }
}
