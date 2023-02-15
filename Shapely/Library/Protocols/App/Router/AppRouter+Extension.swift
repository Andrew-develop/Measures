import RxSwift
import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?

    var rx_dismissed: Observable<Void> { get }
}

protocol AlertPresenter {
    func presentAlert(_ alertController: UIAlertController, _ animated: Bool)
}

extension Presentable where Self: UIViewController {
    func toPresent() -> UIViewController? {
        return self
    }
}

extension UIViewController: Presentable {
    var rx_dismissed: Observable<Void> {
        return rx.methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
            .filter { [weak self] _ in
                guard let strongSelf = self else { return false }

                return strongSelf.isBeingDismissed || strongSelf.isMovingFromParent
            }
            .map { _ in }
    }

    var rx_willDismissed: Observable<Void> {
        return rx.methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
            .filter { [weak self] _ in
                guard let strongSelf = self else { return false }

                return strongSelf.isBeingDismissed || strongSelf.isMovingFromParent
            }
            .map { _ in }
    }
}
