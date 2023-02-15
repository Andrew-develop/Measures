import UIKit

// MARK: - Implement style type

public typealias Style<Element: Stylable> = (Element, Theme.Type) -> Void

// MARK: - StyleWrapper

public enum StyleWrapper<Element: Stylable> {
    case wrap(style: Style<Element>)
}

// MARK: - Stylable

public protocol Stylable {}
extension UIView: Stylable {}

// MARK: - Stylable default implementation

public extension Stylable {
    var theme: Theme.Type {
        guard let appDelegate = UIApplication.shared.delegate as? MainAppDelegate else {
            NSLog("MainAppDelegate was not set")
            return DefaultTheme.self
        }
        return appDelegate.theme
    }

    /**
        Apply styles for Stylable object
     */
    func apply(_ styles: [StyleWrapper<Self>]) {
        styles.forEach {
            switch $0 {
            case let .wrap(style):
                style(self, theme)
            }
        }
    }

    /**
     Apply style for Stylable object
     */
    func apply(_ style: StyleWrapper<Self>) {
        switch style {
        case let .wrap(style):
            style(self, theme)
        }
    }
}
