import UIKit

public protocol MainAppDelegate: UIApplicationDelegate {
    /**
     Implement this property to set custom theme.
     */
    var theme: Theme.Type { get }
}
