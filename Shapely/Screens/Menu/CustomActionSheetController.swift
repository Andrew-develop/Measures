//
//  CustomActionSheetController.swift
//  BillingUI
//
//  Created by snn on 12.06.2021.
//

import UIKit

final class CustomActionSheetController: UIViewController {
    private let alert = CustomActionSheet()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideAction))
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)

        view.addSubview(alert)
    }

    func createView(props: CustomActionSheet.Props, sourceView: UIView, place: Place) {
        alert.dismiss = .init { [weak self] closure in
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.view.layer.opacity = 0
            } completion: { [weak self] _ in
                self?.dismiss(animated: false, completion: closure)
            }
        }

        alert.props = props

        alert.frame.size = alert.sizeThatFits(CGSize(width: 255, height: 365))

        let convert = sourceView.convert(sourceView.bounds.origin, to: view)

        switch place {
        case .topRightToBottomRight:
            alert.frame.origin = CGPoint(x: convert.x + sourceView.bounds.size.width - alert.frame.size.width,
                                         y: convert.y + sourceView.bounds.size.height)
        case .topRightToBottomLeft:
            alert.frame.origin = CGPoint(x: convert.x - alert.frame.size.width,
                                         y: convert.y + sourceView.bounds.size.height)
        case .default:
            guard let frame = UIApplication.shared.windows.first?.frame else { return }

            alert.frame.origin.x = convert.x + min(sourceView.bounds.size.width - alert.frame.size.width, 40) / 2

            if alert.frame.maxX > frame.width {
                alert.frame.origin.x = frame.width - alert.frame.width - 20
            } else if alert.frame.origin.x < 0 {
                alert.frame.origin.x = 20
            }

            alert.frame.origin.y = convert.y + sourceView.bounds.size.height - 20

            if alert.frame.maxY > frame.maxY {
                alert.frame.origin.y = frame.maxY - alert.frame.height - 20
            }
        }
    }

    @objc private func hideAction() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.view.layer.opacity = 0
        } completion: {[weak self] _ in
            self?.dismiss(animated: false, completion: nil)
        }
    }

    enum Place {
        case topRightToBottomRight
        case topRightToBottomLeft
        case `default`
    }
}

extension CustomActionSheetController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        !alert.frame.contains(touch.location(in: nil))
    }
}
