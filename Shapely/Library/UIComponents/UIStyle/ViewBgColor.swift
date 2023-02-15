import UIKit

public extension StyleWrapper where Element == UIView {
    /// Background color for View with background color from app theme palette
    static let backgroundColor: StyleWrapper = .wrap { view, theme in
        view.backgroundColor = theme.colorPalette.background
    }

    /// Background color for View with surface color from app theme palette
    static let surfaceColor: StyleWrapper = .wrap { view, theme in
        view.backgroundColor = theme.colorPalette.surface
    }

    /// Background color for View with surfaceSecondary color from app theme palette
    static let surfaceSecondaryColor: StyleWrapper = .wrap { view, theme in
        view.backgroundColor = theme.colorPalette.surfaceSecondary
    }

    /// Background color for View with text color from app theme palette
    static let textColor: StyleWrapper = .wrap { view, theme in
        view.backgroundColor = theme.colorPalette.text
    }

    /// Background color for View with textSecondary color from app theme palette
    static let textSecondaryColor: StyleWrapper = .wrap { view, theme in
        view.backgroundColor = theme.colorPalette.textSecondary
    }

    /// Background color for View with button color from app theme palette
    static let buttonColor: StyleWrapper = .wrap { view, theme in
        view.backgroundColor = theme.colorPalette.button
    }
}
