import UIKit
extension UIAlertController: Stylable {}

extension StyleWrapper where Element == UIAlertController {
    static var primary: StyleWrapper {
        return .wrap { alert, theme in
            alert.view.tintColor = theme.colorPalette.button
        }
    }
}
