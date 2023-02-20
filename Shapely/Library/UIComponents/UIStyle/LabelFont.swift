import UIKit

public extension StyleWrapper where Element == UILabel {
    /// Set label font to h1 from app theme typography
    static let header1: StyleWrapper = .wrap { label, theme in
        label.font = theme.typography.header1
    }

    /// Set label font to h2 from app theme typography
    static let header2: StyleWrapper = .wrap { label, theme in
        label.font = theme.typography.header2
    }

    /// Set label font to body1 from app theme typography
    static let body1: StyleWrapper = .wrap { label, theme in
        label.font = theme.typography.body1
    }

    /// Set label font to body2 from app theme typography
    static let body2: StyleWrapper = .wrap { label, theme in
        label.font = theme.typography.body2
    }

    /// Set label font to title3 from app theme typography
    static let title3: StyleWrapper = .wrap { label, theme in
        label.font = theme.typography.title3
    }

    /// Set label font to title4 from app theme typography
    static let title4: StyleWrapper = .wrap { label, theme in
        label.font = theme.typography.title4
    }

    /// Set label font to footnote from app theme typography
    static let footnote: StyleWrapper = .wrap { label, theme in
        label.font = theme.typography.footnote
    }
}
